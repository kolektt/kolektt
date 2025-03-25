// view_models/analytics_vm.dart
import 'package:flutter/cupertino.dart';
import 'package:kolektt/model/local/collection_record.dart';

import '../model/collection_analytics.dart';
import '../model/decade_analytics.dart';
import '../model/genre_analytics.dart';
import '../model/artist_analytics.dart';

class AnalyticsViewModel extends ChangeNotifier {
  CollectionAnalytics? analytics;
  bool hasData = false;

  void analyzeRecords(List<CollectionRecord> records) {
    int totalRecords = records.length;

    // 1. 장르별 집계 (각 레코드의 genre 문자열을 ", " 기준으로 분리하여 집계)
    Map<String, int> genreCounts = {};
    for (final record in records) {
      if (record.record.genre.isNotEmpty) {
        // 문자열을 ", " 기준으로 분리
        List<String> genres = record.record.genre.split(', ');
        for (final genre in genres) {
          genreCounts[genre] = (genreCounts[genre] ?? 0) + 1;
        }
      }
    }
    String mostCollectedGenre = genreCounts.isNotEmpty
        ? genreCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key
        : '';

    // 2. 아티스트별 집계 (각 레코드의 첫번째 아티스트 기준)
    Map<String, int> artistCounts = {};
    for (final record in records) {
      if (record.record.artist.isNotEmpty) {
        // artist 문자열을 ", " 기준으로 분리
        List<String> artists = record.record.artist.split(', ');
        for (final artist in artists) {
          artistCounts[artist] = (artistCounts[artist] ?? 0) + 1;
        }
      }
    }
    String mostCollectedArtist = artistCounts.isNotEmpty
        ? artistCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key
        : '';

    // 3. 연대별 집계 (record.releaseYear 기준)
    Map<String, int> decadeCounts = {};
    for (final record in records) {
      if (record.record.releaseYear > 0) {
        int decadeStart = (record.record.releaseYear ~/ 10) * 10;
        String decadeLabel = "${decadeStart}'s";
        decadeCounts[decadeLabel] = (decadeCounts[decadeLabel] ?? 0) + 1;
      }
    }

    // 4. 가장 오래된/최신 레코드 연도 계산
    int oldestRecord = records.isNotEmpty
        ? records
            .map((r) => r.record.releaseYear)
            .reduce((a, b) => a < b ? a : b)
        : 0;
    int newestRecord = records.isNotEmpty
        ? records
            .map((r) => r.record.releaseYear)
            .reduce((a, b) => a > b ? a : b)
        : 0;

    // 5. CollectionAnalytics 객체 생성
    // Artist analysis - get top 5 artists
    final sortedArtists = artistCounts.entries
      .toList()
      ..sort((a, b) => b.value.compareTo(a.value));
      
    // Update the artist analysis section
    final List<ArtistAnalytics> topArtists = sortedArtists
      .take(5)
      .map((entry) => ArtistAnalytics(name: entry.key, count: entry.value))
      .toList();
  
    analytics = CollectionAnalytics(
      totalRecords: totalRecords,
      mostCollectedGenre: mostCollectedGenre,
      mostCollectedArtist: mostCollectedArtist,
      oldestRecord: oldestRecord,
      newestRecord: newestRecord,
      genres: genreCounts.entries
          .map((entry) => GenreAnalytics(name: entry.key, count: entry.value))
          .toList(),
      decades: decadeCounts.entries
          .map(
              (entry) => DecadeAnalytics(decade: entry.key, count: entry.value))
          .toList(),
      artists: topArtists,
    );
    hasData = totalRecords > 0;
    notifyListeners();
  }
}
