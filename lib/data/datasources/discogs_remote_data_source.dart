import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../domain/entities/discogs_record.dart';

class DiscogsRemoteDataSource {
  static const String baseUrl = 'https://api.discogs.com';

  // TODO: .env 파일로 이동
  static const String apiKey = 'AKbXcCERIpZjuzCiOBLt';
  static const String apiSecret = 'BUDuGFBBkChCYYCiRbyWvVxEPlEbqVkX';

  Future<List<DiscogsRecord>> searchDiscogs(String query, {String? type}) async {
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

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'] ?? [];

        return results
            .map((item) => DiscogsRecord(
                  id: item['id'],
                  title: item['title'],
                  resourceUrl: item['resource_url'],
                  artists: item['artist'],
                  notes: item['notes'],
                  genre: item['genre'],
                  coverImage: item['cover_image'],
                  catalogNumber: item['catalog_number'],
                  label: item['label'],
                  format: item['format'],
                  country: item['country'],
                  style: item['style'],
                  condition: item['condition'],
                  conditionNotes: item['condition_notes'],
                  recordId: item['record_id'],
                  artist: item['artist'],
                  releaseYear: item['release_year'],
                ))
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
        return DiscogsRecord(
          id: data['id'],
          title: data['title'],
          resourceUrl: data['resource_url'],
          artists: data['artist'],
          notes: data['notes'],
          genre: data['genre'],
          coverImage: data['cover_image'],
          catalogNumber: data['catalog_number'],
          label: data['label'],
          format: data['format'],
          country: data['country'],
          style: data['style'],
          condition: data['condition'],
          conditionNotes: data['condition_notes'],
          recordId: data['record_id'],
          artist: data['artist'],
          releaseYear: data['release_year'],
        );
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
