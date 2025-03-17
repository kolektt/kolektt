// data/datasources/google_vision_data_source.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../models/exceptions.dart';

class GoogleVisionDataSource {
  final Logger logger = Logger();

  Future<T> _retryRequest<T>(Future<T> Function() fn, {int retries = 3}) async {
    for (var i = 0; i < retries; i++) {
      try {
        return await fn().timeout(const Duration(seconds: 10));
      } on ApiException {
        rethrow;
      } catch (e) {
        if (i == retries - 1) throw NetworkException('요청 재시도 실패: ${e.toString()}');
        await Future.delayed(const Duration(seconds: 1));
      }
    }
    throw NetworkException('알 수 없는 네트워크 오류');
  }

  Map<String, dynamic> _parseJsonResponse(String body) {
    try {
      return json.decode(body);
    } catch (e) {
      throw JsonParseException('JSON 파싱 실패: ${e.toString()}');
    }
  }
  final String apiKey;
  final String project;

  GoogleVisionDataSource({
    required this.apiKey,
    required this.project,
  });

  // 이미지와 감지 유형을 받아서 Vision API 호출 후, 첫 번째 응답 데이터를 반환하는 공통 메소드
  Future<Map<String, dynamic>> _sendRequest(File image, List<String> detectionTypes) async {
    final base64Image = base64Encode(await image.readAsBytes());
    final url = Uri.parse(
        'https://vision.googleapis.com/v1/images:annotate?key=$apiKey');
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

    // debugPrint('Google Vision API Response: ${response.body}');

    if (response.statusCode != 200) {
      throw ApiException(
        'Google Vision API 호출 실패',
        {'status': response.statusCode, 'body': response.body},
      );
    }

    final data = _parseJsonResponse(response.body);
    final responses = data['responses'];
    if (responses == null || responses.isEmpty) {
      throw Exception('Google Vision API로부터 응답이 없습니다.');
    }
    return responses[0];
  }

  /// detectionTypes 인자에 따라 웹, 텍스트 감지 등 원하는 기능을 수행하는 범용 메소드
  Future<Map<String, dynamic>> analyzeImage(File image, {required List<String> detectionTypes}) async {
    final responseData = await _sendRequest(image, detectionTypes);
    final result = <String, dynamic>{};

    if (detectionTypes.contains('WEB_DETECTION')) {
      final webDetection = responseData['webDetection'];
      String? bestGuessLabel;
      List<String> partialMatchingImagesList = [];
      if (webDetection != null) {
        final bestGuessLabels = webDetection['bestGuessLabels'];
        if (bestGuessLabels != null &&
            bestGuessLabels is List &&
            bestGuessLabels.isNotEmpty) {
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
          debugPrint("partialMatchingImagesList: $partialMatchingImagesList");
        }
      }
      result['bestGuessLabel'] = bestGuessLabel;
      result['partialMatchingImages'] = partialMatchingImagesList;
    }

    if (detectionTypes.contains('TEXT_DETECTION')) {
      final textAnnotations = responseData['textAnnotations'];
      String? fullDetectedText;
      if (textAnnotations != null &&
          textAnnotations is List &&
          textAnnotations.isNotEmpty) {
        // 첫 번째 항목은 전체 텍스트 감지 결과입니다.
        fullDetectedText = textAnnotations.first['description'] as String?;
        debugPrint("Detected Text: $fullDetectedText");
      }
      result['fullDetectedText'] = fullDetectedText;
    }

    return result;
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
