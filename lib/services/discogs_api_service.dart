import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../model/discogs_record.dart';

class DiscogsApiService {
  static const String baseUrl = 'https://api.discogs.com';

  // TODO: .env 파일로 이동
  static const String apiKey = 'AKbXcCERIpZjuzCiOBLt';
  static const String apiSecret = 'BUDuGFBBkChCYYCiRbyWvVxEPlEbqVkX';

  Future<List<DiscogsRecord>> searchDiscogs(String query) async {
    if (query.isEmpty) {
      return [];
    }

    try {
      final uri = Uri.parse('$baseUrl/database/search?q=$query&key=$apiKey&secret=$apiSecret');
      debugPrint('Searching Discogs: $uri');

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

  Future<DiscogsRecord> getReleaseById(int releaseId) async {
    final uri = Uri.parse('$baseUrl/releases/$releaseId'
        '?key=$apiKey&secret=$apiSecret');
    debugPrint('Fetching Discogs Release: $uri');

    try {
      final response = await http.get(
        uri,
        headers: {
          'User-Agent': 'MyDiscogsApp/1.0',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return DiscogsRecord.fromJson(data);
      } else {
        debugPrint(
          'Failed to load release: ${response.statusCode} - ${response.body}',
        );
        throw Exception('Release 조회 실패 (Status: ${response.statusCode})');
      }
    } catch (e) {
      debugPrint('Error fetching release: $e');
      throw Exception('네트워크 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }
}
