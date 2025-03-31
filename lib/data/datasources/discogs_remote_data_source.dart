import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:kolektt/exceptions/data_source_exception.dart';

import '../models/artist_release.dart';
import '../models/discogs_record.dart';
import '../models/discogs_record.dart' as data;
import '../models/discogs_search_response.dart';

class DiscogsRemoteDataSource {
  static const String baseUrl = 'https://api.discogs.com';

  static String apiKey = dotenv.env["DISCOGS_API_KEY"] ?? "";
  static String apiSecret = dotenv.env["DISCOGS_API_SECRET_KEY"] ?? "";

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
        throw DataSourceException('Failed to load search results: ${response.statusCode}');
      }

      final Map<String, dynamic> jsonData = json.decode(response.body);
      debugPrint("Discogs search results: $jsonData");
      final DiscogsSearchResponse discogsSearchResponse = DiscogsSearchResponse.fromJson(jsonData);
      debugPrint('Discogs search response: $discogsSearchResponse');
      final List<DiscogsSearchItem> results = discogsSearchResponse.results;
      return results;
    } catch (e) {
      debugPrint('Error searching Discogs: $e');
      throw DataSourceException('네트워크 오류가 발생했습니다. 다시 시도해주세요.', e);
    }
  }

  Future<DiscogsRecord> getReleaseById(int releaseId) async {
    final uri = Uri.parse('$baseUrl/releases/$releaseId?key=$apiKey&secret=$apiSecret');
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
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final DiscogsRecord discogsRecord = DiscogsRecord.fromJson(jsonData);
        debugPrint('Discogs release: ${discogsRecord.title}');
        return discogsRecord;
      } else {
        debugPrint('Failed to load release: ${response.statusCode} - ${response.body}');
        throw DataSourceException('Release 조회 실패 (Status: ${response.statusCode})');
      }
    } catch (e) {
      debugPrint('Error fetching release: $e');
      throw DataSourceException('네트워크 오류가 발생했습니다. 다시 시도해주세요.', e);
    }
  }

  Future<data.DiscogsRecord> getDomainReleaseById(int release) async {
    final uri = Uri.parse('$baseUrl/releases/$release?key=$apiKey&secret=$apiSecret');
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
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final data.DiscogsRecord discogsRecord = data.DiscogsRecord.fromJson(responseData);
        debugPrint('Discogs release: ${discogsRecord.title}');
        return discogsRecord;
      } else {
        debugPrint('Failed to load release: ${response.statusCode} - ${response.body}');
        throw DataSourceException('Release 조회 실패 (Status: ${response.statusCode})');
      }
    } catch (e) {
      debugPrint('Error fetching release: $e');
      throw DataSourceException('네트워크 오류가 발생했습니다. 다시 시도해주세요.', e);
    }
  }

  Future<Artist> getArtistByUrl(String url) async {
    final uri = Uri.parse('$url?key=$apiKey&secret=$apiSecret');
    debugPrint('Fetching Discogs Artist: $uri');
    try {
      final response = await http.get(
        uri,
        headers: {
          'User-Agent': 'MyDiscogsApp/1.0',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final Artist artist = Artist.fromJson(jsonData);
        debugPrint('Discogs artist: ${artist.toJson()}');
        return artist;
      } else {
        debugPrint('Failed to load artist: ${response.statusCode} - ${response.body}');
        throw DataSourceException('Artist 조회 실패 (Status: ${response.statusCode})');
      }
    } catch (e) {
      debugPrint('Error fetching artist: $e');
      throw DataSourceException('네트워크 오류가 발생했습니다. 다시 시도해주세요.', e);
    }
  }

  Future<ArtistRelease> getArtistReleaseByUrl(String url) async {
    final uri = Uri.parse('$url?key=$apiKey&secret=$apiSecret');
    debugPrint('Fetching Discogs Artist Release: $uri');

    try {
      final response = await http.get(
        uri,
        headers: {
          'User-Agent': 'MyDiscogsApp/1.0',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final ArtistRelease artistRelease = ArtistRelease.fromJson(jsonData);
        debugPrint('Discogs artist release: ${artistRelease.toJson()}');
        return artistRelease;
      } else {
        debugPrint('Failed to load artist release: ${response.statusCode} - ${response.body}');
        throw DataSourceException('Artist 조회 실패 (Status: ${response.statusCode})');
      }
    } catch (e) {
      debugPrint('Error fetching artist release: $e');
      throw DataSourceException('네트워크 오류가 발생했습니다. 다시 시도해주세요.', e);
    }
  }
}
