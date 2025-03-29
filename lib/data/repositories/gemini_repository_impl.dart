import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../domain/repositories/gemini_repository.dart';

/// Gemini API 구현
class GeminiApiRepository implements IGeminiRepository {
  @override
  Future<String> generateLabel(List<String> titles) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) throw Exception('GEMINI_API_KEY 환경변수가 설정되어 있지 않습니다.');

    final model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 1,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 8192,
        responseMimeType: 'text/plain',
      ),
      systemInstruction: Content.system(
          '다음 리스트에서 문자열들을 분석하여 가장 적절한 앨범 검색 키워드 하나를 제시해주세요. '
              '관련된 앨범 이름이 있다면 우선적으로 고려하고, 없다면 가장 관련성이 높은 단어를 조합하여 키워드를 생성합니다.\n\n'
              '리스트:\n\n${jsonEncode(titles)}\n\n기대 출력:\n\n앨범 이름'),
    );

    // 초기 대화 기록에 빈 TextPart 없이 title 리스트만 포함
    final chat = model.startChat(history: [
      Content.multi([
        TextPart('${jsonEncode(titles)}'),
      ]),
    ]);

    final message = '분석 후 앨범 키워드를 알려주세요.';
    final content = Content.text(message);

    try {
      final response = await chat.sendMessage(content);
      return response.text!.trim();
    } catch (e) {
      throw Exception("Gemini API 호출 오류: $e");
    }
  }
}
