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
    this.project = 'kolektt',
  });

  Future<String?> recognizeAlbumLabel(File image) async {
    final base64Image = base64Encode(await image.readAsBytes());
    final url = Uri.parse('https://vision.googleapis.com/v1/images:annotate');

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
        'Authorization': "Bearer $apiKey",
        'x-goog-user-project': project,
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
    final bestGuessLabels =
        data['responses']?[0]?['webDetection']?['bestGuessLabels'];
    if (bestGuessLabels != null && bestGuessLabels.isNotEmpty) {
      return bestGuessLabels.first['label'] as String?;
    } else {
      return null;
    }
  }
}
