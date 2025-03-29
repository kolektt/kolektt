/// 리포지토리 인터페이스: Gemini API 호출
abstract class IGeminiRepository {
  Future<String> generateLabel(List<String> titles);
}
