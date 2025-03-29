import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../domain/repositories/lens_repository.dart';

/// Lens API 구현
class LensApiRepository implements ILensRepository {
  static const String lensEndpoint = 'https://google.serper.dev/lens';

  @override
  Future<Map<String, dynamic>> fetchLensData(String imageUrl) async {
    final headers = {
      'X-API-KEY': dotenv.env['SERPER_API_KEY'] ?? '',
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      "url": imageUrl,
      "gl": "kr",
      "hl": "ko"
    });

    final response = await http.post(Uri.parse(lensEndpoint), headers: headers, body: body);
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception("Lens API 응답 에러: ${response.statusCode} ${response.reasonPhrase}");
    }
  }
}
