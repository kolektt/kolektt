// data/datasources/google_vision_data_source.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart'; // debugPrint
import 'package:http/http.dart' as http;

class GoogleVisionDataSource {
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

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=utf-8'},
      body: jsonEncode(requestBody),
    );

    // debugPrint('Google Vision API Response: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception(
          'Google Vision API 호출 실패 (Status: ${response.statusCode})');
    }

    final data = json.decode(response.body);
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
