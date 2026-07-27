import 'dart:developer';
import 'package:cost_it_mobile/app/global/utils/config.dart';
import 'package:cost_it_mobile/app/global/utils/exception.dart';
import 'package:cost_it_mobile/app/global/utils/providers.dart';
import 'package:cost_it_mobile/app/network/client.dart';
import 'package:cost_it_mobile/app/global/utils/interceptors.dart';
import 'package:cost_it_mobile/app/network/models.dart';
import 'package:cost_it_mobile/app/root/root_app.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DioNetworkClient implements NetworkClient {
  DioNetworkClient(this._dio);

  final Dio _dio;

  @override
  Future<NetworkResponse<T>> delete<T>(String url) async {
    try {
      final response = await _dio.delete(url);
      return NetworkResponse(data: response.data as T);
    } catch (e) {
      return _handleError(e);
    }
  }

  @override
  Future<NetworkResponse<T>> get<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(url, queryParameters: queryParameters);
      return NetworkResponse(
        data: response.data as T,
        statusCode: response.statusCode,
      );
    } catch (error) {
      return _handleError(error);
    }
  }

  @override
  Future<NetworkResponse<T>> patch<T>(
    String url, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _dio.patch(url, data: data);
      return NetworkResponse(
        data: response.data as T,
        statusCode: response.statusCode,
        headers: response.headers.map,
        rawResponse: response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : null,
      );
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  @override
  Future<NetworkResponse<T>> post<T>(String url, {data}) async {
    try {
      final response = await _dio.post(url, data: data);
      return NetworkResponse(
        data: response.data as T,
        headers: response.headers.map,
        rawResponse: response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : null,
        statusCode: response.statusCode,
      );
    } catch (e) {
      return _handleError(e);
    }
  }

  @override
  Future<NetworkResponse<T>> put<T>(
    String url, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _dio.put(url, data: data);
      return NetworkResponse(
        data: response.data as T,
        statusCode: response.statusCode,
        headers: response.headers.map,
        rawResponse: response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : null,
      );
    } catch (e) {
      return _handleError<T>(e);
    }
  }
}

NetworkResponse<T> _handleError<T>(dynamic error) {
  if (error is DioException && error.error is GlobalException) {
    final ex = error.error as GlobalException;
    log('_handleError — type: ${ex.type}, raw: ${ex.raw}, message: ${ex.message}');
    throw ex;
  }

  if (error is DioException) {
    log('Unintercepted DioException: ${error.type} ${error.response?.statusCode}');
    throw GlobalException(
      type: ErrorType.unknown,
      message: error.message,
      statusCode: error.response?.statusCode,
    );
  }

  log('Non-Dio error in _handleError: $error');
  throw GlobalException(type: ErrorType.unknown);
}


final rawDioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      sendTimeout: AppConfig.instance.sendTimeout,
      connectTimeout: AppConfig.instance.sendTimeout,
      receiveTimeout: AppConfig.instance.receiveTimeout,
      baseUrl: AppConfig.instance.baseAppUrl,
    ),
  );

  dio.interceptors.add(
    AppInterceptors(
      dio: dio,
      getToken: () => ref.read(appStateProvider).user?.authToken,
      getRefreshToken: () => ref.read(appStateProvider).user?.refreshToken,
      onTokenRefreshed: (accessToken, refreshToken) {
        ref.read(appStateProvider.notifier).updateTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
      },
      // Called only when refresh also fails — clear session and navigate to login.
      onUnauthorized: () {
        if (ref.read(appStateProvider).user == null) return;

        ref.read(appStateProvider.notifier).logout();

        final nav = appNavigatorKey.currentState;
        if (nav != null && nav.mounted) {
          nav.pushNamedAndRemoveUntil(
            PageRoutes.login.name,
            (route) => false,
          );
        }
      },
    ),
  );

  return dio;
});

final dioClientProvider = Provider<NetworkClient>((ref) {
  return DioNetworkClient(ref.watch(rawDioProvider));
});