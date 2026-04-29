import 'dart:developer';

import 'package:cost_it_mobile/app/global/exception.dart';
import 'package:dio/dio.dart';

class AppInterceptors extends Interceptor {
  final Dio dio;
  final String? Function() getToken;
  AppInterceptors({required this.dio, required this.getToken});

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
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('Interceptor error: ${err.response?.statusCode} ${err.type}');

    final response = err.response;
    final message = _extractRaw(response?.data);

    //  message from backend
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
  final isTokenError =
      statusCode == 401 &&  
      message != null &&
      (message.contains('token expired') ||
          message.contains('invalid signature') ||
          message.contains('jwt expired'));

        if (statusCode == 401 || isTokenError) {
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
        return handler.next(err); //// swallow cancelled requests

      case DioExceptionType.unknown:
      default:
        final statusCode = response?.statusCode;

        final isTokenError =
            (statusCode == 401) &&
            message != null &&
            (message.contains('token expired') ||
                message.contains('invalid signature') ||
                message.contains('jwt expired'));

        if (isTokenError) {
          return handler.reject(
            _wrap(
              err,
              GlobalException(type: ErrorType.unauthorized, message: message),
            ),
          );
        }
        log('Incoming error: $err');
        log('Type: ${err.runtimeType}');

        return handler.reject(
          _wrap(err, GlobalException(type: ErrorType.noInternet)),
        );
    }
  }

  // Wraps GlobalException into a DioException so Dio's pipeline stays happy
  DioException _wrap(DioException original, GlobalException appEx) {
    return DioException(
      requestOptions: original.requestOptions,
      response: original.response,
      error: appEx, // <-- key: stored in .error field
      type: original.type,
    );
  }

  // Safe raw message extraction for internal logging only
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
