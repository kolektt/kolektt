/// 데이터 레이어에서 발생하는 에러를 캡슐화하기 위한 사용자 정의 예외 클래스
class DataSourceException implements Exception {
  final String message;
  final dynamic originalError;

  DataSourceException(this.message, [this.originalError]);

  @override
  String toString() =>
      "DataSourceException: $message\nOriginal error: $originalError";
}
