import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../model/discogs_record.dart';

class DiscogsApiService {
  static const String baseUrl = 'https://api.discogs.com';

  // TODO: 실제 API 키로 교체하세요
  static const String apiKey = 'YOUR_DISCOGS_API_KEY';
  static const String apiSecret = 'YOUR_DISCOGS_API_SECRET';

  Future<List<DiscogsRecord>> searchDiscogs(String query) async {
    if (query.isEmpty) {
      return [];
    }

    try {
      final uri = Uri.parse('$baseUrl/database/search?q=$query&key=$apiKey&secret=$apiSecret');

      final response = await http.get(
        uri,
        headers: {
          'User-Agent': 'MyDiscogsApp/1.0',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'] ?? [];

        return results
            .map((item) => DiscogsRecord.fromJson(item))
            .toList();
      } else {
        throw Exception('Failed to load search results: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error searching Discogs: $e');
      throw Exception('네트워크 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

  Future<DiscogsRecord> getRecordDetails(int id) async {
    try {
      final uri = Uri.parse('$baseUrl/releases/$id?key=$apiKey&secret=$apiSecret');

      final response = await http.get(
        uri,
        headers: {
          'User-Agent': 'MyDiscogsApp/1.0',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return DiscogsRecord.fromJson(data);
      } else {
        throw Exception('Failed to load record details: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error getting record details: $e');
      throw Exception('레코드 정보를 불러오는데 실패했습니다.');
    }
  }
}
