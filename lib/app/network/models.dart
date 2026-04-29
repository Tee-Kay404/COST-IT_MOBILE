class NetworkResponse<T> {
  final T? data;
  final int? statusCode;
  final String? message;
  final Map<String, List<String>>? headers;
  final Map<String, dynamic>? rawResponse;
  NetworkResponse({
    this.data,
    this.statusCode,
    this.message,
    this.headers,
    this.rawResponse,
  });

  bool get success {
    return statusCode == 200 || statusCode == 201;
  }

  NetworkResponse<R> transform<R>(R Function(T data) transformer) {
    if (!success || data == null) {
      return NetworkResponse<R>(
        data: data as R,
        statusCode: statusCode,
        message: message ?? 'Unknown error',
      );
    }
    return NetworkResponse(
      data: transformer(data as T),
      statusCode: statusCode,
      message: message,
    );
  }
}
