enum ErrorType {
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  conflict,
  serverError,
  noInternet,
  timeout,
  unknown,
}

class GlobalException implements Exception {
  final ErrorType type;
  final String? message;
  final int? statusCode;
  final dynamic raw;

  const GlobalException({
    required this.type,
    this.message,
    this.statusCode,
    this.raw,
  });

  @override
  String toString() => 'GlobalException(type: $type, status: $statusCode)';
}
