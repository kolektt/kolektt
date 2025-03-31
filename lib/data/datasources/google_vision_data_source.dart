// data/datasources/google_vision_data_source.dart
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../models/exceptions.dart';

class GoogleVisionDataSource {
  final Logger logger = Logger();

  Future<T> _retryRequest<T>(Future<T> Function() fn, {int retries = 3}) async {
    for (var i = 0; i < retries; i++) {
      try {
        logger.i("요청 시도 ${i + 1}회");
        return await fn().timeout(const Duration(seconds: 10));
      } on ApiException catch (e) {
        logger.e("API Exception 발생: ${e.message}");
        rethrow;
      } catch (e, stackTrace) {
        logger.e("요청 시도 ${i + 1}회 실패: $e", error: e, stackTrace: stackTrace);
        if (i == retries - 1) {
          throw NetworkException('요청 재시도 실패: ${e.toString()}');
        }
        await Future.delayed(const Duration(seconds: 1));
      }
    }
    throw NetworkException('알 수 없는 네트워크 오류');
  }

  Map<String, dynamic> _parseJsonResponse(String body) {
    try {
      return json.decode(body);
    } catch (e) {
      logger.e("JSON 파싱 오류: $e");
      throw JsonParseException('JSON 파싱 실패: ${e.toString()}');
    }
  }

  final String apiKey;
  final String project;

  GoogleVisionDataSource({
    required this.apiKey,
    required this.project,
  });

  Future<Map<String, dynamic>> _sendRequest(File image, List<String> detectionTypes) async {
    try {
      final base64Image = base64Encode(await image.readAsBytes());
      final url = Uri.parse('https://vision.googleapis.com/v1/images:annotate?key=$apiKey');
      final features = detectionTypes.map((type) => {'type': type}).toList();

      final requestBody = {
        'requests': [
          {
            'image': {'content': base64Image},
            'features': features,
          }
        ]
      };

      final response = await _retryRequest(
            () => http.post(
          url,
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: jsonEncode(requestBody),
        ),
        retries: 3,
      );

      if (response.statusCode != 200) {
        logger.e("Google Vision API 호출 실패: ${response.statusCode} - ${response.body}");
        throw ApiException(
          'Google Vision API 호출 실패',
          {'status': response.statusCode, 'body': response.body},
        );
      }

      final data = _parseJsonResponse(response.body);
      final responses = data['responses'];
      if (responses == null || responses.isEmpty) {
        logger.e("Google Vision API로부터 응답이 없습니다.");
        throw ApiException('응답 오류', {'message': 'Google Vision API로부터 응답이 없습니다.'});
      }
      return responses[0];
    } catch (e) {
      logger.e("요청 전송 중 오류 발생: $e");
      rethrow;
    }
  }

  /// detectionTypes에 따라 이미지 분석을 수행하는 범용 메소드
  Future<Map<String, dynamic>> analyzeImage(File image, {required List<String> detectionTypes}) async {
    try {
      final responseData = await _sendRequest(image, detectionTypes);
      final result = <String, dynamic>{};

      if (detectionTypes.contains('WEB_DETECTION')) {
        final webDetection = responseData['webDetection'];
        String? bestGuessLabel;
        List<String> partialMatchingImagesList = [];
        if (webDetection != null) {
          final bestGuessLabels = webDetection['bestGuessLabels'];
          if (bestGuessLabels != null && bestGuessLabels is List && bestGuessLabels.isNotEmpty) {
            bestGuessLabel = bestGuessLabels.first['label'] as String?;
          }
          final pagesWithMatching = webDetection['pagesWithMatchingImages'];
          if (pagesWithMatching != null && pagesWithMatching is List) {
            for (var page in pagesWithMatching) {
              final title = page['pageTitle'] as String?;
              if (title != null) {
                partialMatchingImagesList.add(title);
              }
            }
            logger.i("partialMatchingImagesList: $partialMatchingImagesList");
          }
        }
        result['bestGuessLabel'] = bestGuessLabel;
        result['partialMatchingImages'] = partialMatchingImagesList;
      }

      if (detectionTypes.contains('TEXT_DETECTION')) {
        final textAnnotations = responseData['textAnnotations'];
        String? fullDetectedText;
        if (textAnnotations != null && textAnnotations is List && textAnnotations.isNotEmpty) {
          fullDetectedText = textAnnotations.first['description'] as String?;
          logger.i("Detected Text: $fullDetectedText");
        }
        result['fullDetectedText'] = fullDetectedText;
      }

      return result;
    } catch (e) {
      logger.e("이미지 분석 중 오류 발생: $e");
      rethrow;
    }
  }

  /// 웹 감지만 수행하는 편의 메소드 (앨범 커버 분석)
  Future<Map<String, dynamic>> analyzeAlbumCover(File image) async {
    return analyzeImage(image, detectionTypes: ['WEB_DETECTION']);
  }

  /// 텍스트 감지만 수행하는 편의 메소드
  Future<String?> analyzeTextDetection(File image) async {
    final result = await analyzeImage(image, detectionTypes: ['TEXT_DETECTION']);
    return result['fullDetectedText'] as String?;
  }
}
