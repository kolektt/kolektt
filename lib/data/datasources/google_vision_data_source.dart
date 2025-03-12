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

  Future<Map<String, dynamic>> analyzeAlbumCover(File image) async {
    final base64Image = base64Encode(await image.readAsBytes());
    final url = Uri.parse('https://vision.googleapis.com/v1/images:annotate?key=$apiKey');

    final requestBody = {
      'requests': [
        {
          'image': {'content': base64Image},
          'features': [
            {'type': 'WEB_DETECTION'}
          ]
        }
      ]
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: jsonEncode(requestBody),
    );

    debugPrint('Google Vision API Response: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception(
          'Google Vision API 호출 실패 (Status: ${response.statusCode})');
    }

    final data = json.decode(response.body);
    final respones = data['responses'];
    final webDetection = respones?[0]?['webDetection'];
    
    final bestGuessLabels = webDetection?['bestGuessLabels'];
    final pagesWithMatching = webDetection?['pagesWithMatchingImages'];

    List<String> partialMatchingImagesList = [];
    if (pagesWithMatching != null) {
      for (var page in pagesWithMatching) {
        final title = page['pageTitle'] as String?;
        if (title != null) {
          partialMatchingImagesList.add(title);
        }
      }
      debugPrint("partialMatchingImagesList: $partialMatchingImagesList");
    }

    String? bestGuessLabel;
    if (bestGuessLabels != null && bestGuessLabels.isNotEmpty) {
      bestGuessLabel = bestGuessLabels.first['label'] as String?;
    }

    return {
      'bestGuessLabel': bestGuessLabel,
      'partialMatchingImages': partialMatchingImagesList,
    };
  }
}
