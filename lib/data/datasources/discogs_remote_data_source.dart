import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/discogs_record.dart';
import '../models/discogs_search_response.dart';

class DiscogsRemoteDataSource {
  static const String baseUrl = 'https://api.discogs.com';

  // TODO: .env 파일로 이동
  static const String apiKey = 'AKbXcCERIpZjuzCiOBLt';
  static const String apiSecret = 'BUDuGFBBkChCYYCiRbyWvVxEPlEbqVkX';

  Future<List<DiscogsSearchItem>> searchDiscogs(String query, {String? type}) async {
    if (query.isEmpty) {
      return [];
    }
    try {
      String url = '$baseUrl/database/search';
      // type별 쿼리 추가
      if (type != null && type.isNotEmpty) {
        if (type == 'artist') {
          url += '?type=artist';
        } else if (type == 'label') {
          url += '?type=label';
        } else if (type == 'release') {
          url += '?type=release';
        } else if (type == 'master') {
          url += '?type=master';
        }
      }
      url += '&q=$query&key=$apiKey&secret=$apiSecret';
      final uri = Uri.parse(url);
      debugPrint('Searching Discogs: $uri');

      final response = await http.get(
        uri,
        headers: {
          'User-Agent': 'MyDiscogsApp/1.0',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to load search results: ${response.statusCode}');
      }

      final Map<String, dynamic> data = json.decode(response.body);
      debugPrint("Discogs search results: ${data}");
      final DiscogsSearchResponse discogs_search_response = DiscogsSearchResponse.fromJson(data);
      debugPrint('Discogs search response: ${discogs_search_response}');
      final List<DiscogsSearchItem> results = discogs_search_response.results;
      debugPrint('Discogs search results: ${results[0].title}');
      return results;
    } catch (e) {
      debugPrint('Error searching Discogs: $e');
      throw Exception('네트워크 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

  Future<DiscogsRecord> getReleaseById(int releaseId) async {
    final uri =
        Uri.parse('$baseUrl/releases/$releaseId?key=$apiKey&secret=$apiSecret');
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
        final DiscogsRecord discogsRecord = DiscogsRecord.fromJson(data);
        debugPrint('Discogs release: ${discogsRecord.title}');
        return discogsRecord;
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
