import 'package:cost_it_mobile/app/network/models.dart';

abstract class NetworkClient {
  Future<NetworkResponse<T>> get<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
  });
  Future<NetworkResponse<T>> post<T>(String url, {dynamic data});
  Future<NetworkResponse<T>> put<T>(String url, {Map<String, dynamic> data});
  Future<NetworkResponse<T>> patch<T>(String url, {Map<String, dynamic> data});
  Future<NetworkResponse<T>> delete<T>(String url);
}
