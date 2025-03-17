class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  NetworkException(this.message, [this.statusCode]);

  @override
  String toString() => 'NetworkException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

class ApiException implements Exception {
  final String message;
  final dynamic responseData;

  ApiException(this.message, [this.responseData]);

  @override
  String toString() => 'ApiException: $message';
}

class JsonParseException implements Exception {
  final String message;

  JsonParseException(this.message);

  @override
  String toString() => 'JsonParseException: $message';
}