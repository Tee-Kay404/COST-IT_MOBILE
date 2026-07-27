import 'dart:async';
import 'dart:developer';

import 'package:cost_it_mobile/app/global/utils/exception.dart';
import 'package:dio/dio.dart';

class AppInterceptors extends Interceptor {
  final Dio dio;
  final String? Function() getToken;
  final String? Function() getRefreshToken;

  /// Called after a successful token refresh — provides the new pair.
  final void Function(String accessToken, String refreshToken)? onTokenRefreshed;

  /// Called when refresh itself fails (token expired/revoked) — triggers logout.
  final void Function()? onUnauthorized;

  // Prevents multiple concurrent refreshes running in parallel.
  bool _isRefreshing = false;
  final List<Completer<String>> _pendingRequests = [];

  AppInterceptors({
    required this.dio,
    required this.getToken,
    required this.getRefreshToken,
    this.onTokenRefreshed,
    this.onUnauthorized,
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = getToken();
    log('Request: ${options.baseUrl + options.path} [${options.method}]');

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    log('Interceptor error: ${err.response?.statusCode} ${err.type}');

    final response = err.response;
    final message = _extractRaw(response?.data);

    log('═══════════════════════════════════');
    log('URL     : ${err.requestOptions.baseUrl}${err.requestOptions.path}');
    log('METHOD  : ${err.requestOptions.method}');
    log('STATUS  : ${err.response?.statusCode}');
    log('HEADERS : ${err.requestOptions.headers}');
    log('PAYLOAD : ${err.requestOptions.data}');
    log('RESPONSE: ${err.response?.data}');
    log('ERROR   : ${err.message}');
    log('═══════════════════════════════════');

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return handler.reject(
          _wrap(err, GlobalException(type: ErrorType.timeout)),
        );

      case DioExceptionType.badResponse:
        final statusCode = response?.statusCode;

        // ── 401 → try refresh first ──────────────────────────────────────────
        if (statusCode == 401) {
          // Skip refresh for auth endpoints to avoid loops
          final path = err.requestOptions.path;
          final isAuthEndpoint = path.contains('auth/login') ||
              path.contains('auth/refresh') ||
              path.contains('auth/register');

          if (!isAuthEndpoint) {
            final retried = await _tryRefreshAndRetry(err, handler);
            if (retried) return;
          }

          // Refresh failed or this is an auth endpoint — log out
          onUnauthorized?.call();
          return handler.reject(
            _wrap(
              err,
              GlobalException(
                type: ErrorType.unauthorized,
                statusCode: statusCode,
                message: message,
                raw: response?.data,
              ),
            ),
          );
        }

        final type = switch (statusCode) {
          400 => ErrorType.badRequest,
          403 => ErrorType.forbidden,
          404 => ErrorType.notFound,
          409 => ErrorType.conflict,
          _ => ErrorType.serverError,
        };

        return handler.reject(
          _wrap(
            err,
            GlobalException(
              type: type,
              statusCode: statusCode,
              message: message,
              raw: response?.data,
            ),
          ),
        );

      case DioExceptionType.cancel:
        return handler.next(err);

      case DioExceptionType.unknown:
      default:
        final statusCode = response?.statusCode;

        if (statusCode == 401) {
          final path = err.requestOptions.path;
          final isAuthEndpoint = path.contains('auth/login') ||
              path.contains('auth/refresh');

          if (!isAuthEndpoint) {
            final retried = await _tryRefreshAndRetry(err, handler);
            if (retried) return;
          }

          onUnauthorized?.call();
          return handler.reject(
            _wrap(
              err,
              GlobalException(type: ErrorType.unauthorized, message: message),
            ),
          );
        }

        log('Incoming error: $err');
        return handler.reject(
          _wrap(err, GlobalException(type: ErrorType.noInternet)),
        );
    }
  }

  // ── Token Refresh Logic ─────────────────────────────────────────────────────

  /// Attempts to refresh the access token and retry the original request.
  /// Returns true if the retry was resolved (success or failure),
  /// false if we should fall through to the normal error path.
  Future<bool> _tryRefreshAndRetry(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final refreshToken = getRefreshToken();
    if (refreshToken == null) {
      log('No refresh token available — cannot refresh.');
      return false;
    }

    // If another request is already refreshing, queue this one
    if (_isRefreshing) {
      log('Refresh in progress — queuing request.');
      final completer = Completer<String>();
      _pendingRequests.add(completer);
      try {
        final newToken = await completer.future;
        final retryOptions = err.requestOptions;
        retryOptions.headers['Authorization'] = 'Bearer $newToken';
        final retryResponse = await dio.fetch(retryOptions);
        handler.resolve(retryResponse);
        return true;
      } catch (e) {
        return false;
      }
    }

    _isRefreshing = true;
    log('Access token expired — attempting refresh…');

    try {
      // Call POST /auth/refresh with the refresh token
      final refreshResponse = await dio.post(
        'auth/refresh',
        data: {'refresh_token': refreshToken},
        options: Options(
          // Do NOT pass the expired auth header for this call
          headers: {'Authorization': null},
        ),
      );

      final newAccessToken = refreshResponse.data['access_token'] as String?;
      final newRefreshToken = refreshResponse.data['refresh_token'] as String?;

      if (newAccessToken == null || newRefreshToken == null) {
        log('Refresh response missing tokens.');
        _failPendingRequests();
        return false;
      }

      log('Token refreshed successfully.');

      // Notify app state to persist new tokens
      onTokenRefreshed?.call(newAccessToken, newRefreshToken);

      // Resolve all queued requests with the new token
      for (final completer in _pendingRequests) {
        completer.complete(newAccessToken);
      }
      _pendingRequests.clear();

      // Retry the original failing request
      final retryOptions = err.requestOptions;
      retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';
      final retryResponse = await dio.fetch(retryOptions);
      handler.resolve(retryResponse);
      return true;
    } catch (e) {
      log('Token refresh failed: $e — logging out.');
      _failPendingRequests();
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  void _failPendingRequests() {
    for (final completer in _pendingRequests) {
      completer.completeError(Exception('Token refresh failed'));
    }
    _pendingRequests.clear();
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  DioException _wrap(DioException original, GlobalException appEx) {
    return DioException(
      requestOptions: original.requestOptions,
      response: original.response,
      error: appEx,
      type: original.type,
    );
  }

  String? _extractRaw(dynamic data) {
    try {
      if (data is Map && data['message'] is String) {
        return data['message'];
      }
      if (data is String && !data.contains('html')) {
        return data;
      }
    } catch (_) {}

    return null;
  }
}
