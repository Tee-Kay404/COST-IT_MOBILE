import 'dart:developer';

import 'package:cost_it_mobile/app/global/config.dart';
import 'package:cost_it_mobile/app/global/exception.dart';
import 'package:cost_it_mobile/app/global/providers.dart';
import 'package:cost_it_mobile/app/network/client.dart';
import 'package:cost_it_mobile/app/global/interceptors.dart';
import 'package:cost_it_mobile/app/network/models.dart';
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
        rawResponse: response.data,
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
        rawResponse: response.data,
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
        rawResponse: response.data,
      );
    } catch (e) {
      return _handleError<T>(e);
    }
  }
}

NetworkResponse<T> _handleError<T>(dynamic error) {
  // GlobalException already typed by interceptor — just rethrow as-is
  if (error is DioException && error.error is GlobalException) {
     final ex = error.error as GlobalException;
    log('_handleError — type: ${ex.type}, raw: ${ex.raw}, message: ${ex.message}');
    throw ex;
  }

  // Raw DioException that somehow bypassed interceptor (shouldn't happen in prod)
  if (error is DioException) {
    log(
      'Unintercepted DioException: ${error.type} ${error.response?.statusCode}',
    );
    throw GlobalException(
      type: ErrorType.unknown,
      message: error.message,
      statusCode: error.response?.statusCode,
    );
  }

  // Truly unexpected local error (null cast, type error, etc.)
  log('Non-Dio error in _handleError: $error');
  throw GlobalException(type: ErrorType.unknown);
}

// FIX — pass the ref, read token fresh on every request
final dioClientProvider = Provider((ref) {
  final dio = Dio(
    BaseOptions(
      
      sendTimeout: AppConfig.instance.sendTimeout,
      connectTimeout:
          AppConfig.instance.sendTimeout, 
      receiveTimeout: AppConfig.instance.receiveTimeout,
      baseUrl: AppConfig.instance.baseAppUrl,
    ),
  );

  dio.interceptors.add(
    AppInterceptors(
      dio: dio,
      getToken: () => ref
          .read(appStateProvider)
          .user
          ?.authToken, // ← closure, fresh every call
    ),
  );

  return DioNetworkClient(dio);
});
