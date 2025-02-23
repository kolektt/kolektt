import 'package:flutter/material.dart';
import 'package:kolektt/model/recognition.dart';
import 'dart:io';
import '../collection_view.dart';

class CollectionViewModel extends ChangeNotifier {
  File? selectedImage;
  RecognitionResult? recognitionResult;
  CollectionAnalytics? analytics;

  Future<RecognitionResult> recognizeAlbum(File image) async {
    // 앨범 인식 로직 구현 필요
    throw UnimplementedError("Not implemented");
  }

  Future<void> processBarcode(File image) async {
    // 바코드 처리 로직 구현 필요
  }

  Future<void> searchBarcode(String barcode) async {
    // 바코드 검색 로직 구현 필요
  }

  Future<void> searchCatNo(String catNo) async {
    // CatNo 검색 로직 구현 필요
  }

  void updateAnalytics(List<Record> records) {
    int totalRecords = records.length;

    // 장르 분석
    var genreGroups = <String, int>{};
    for (var record in records) {
      genreGroups[record.genre ?? "기타"] = (genreGroups[record.genre ?? "기타"] ?? 0) + 1;
    }

    var genres = genreGroups.entries.map((entry) => GenreAnalytics(
      name: entry.key,
      count: entry.value,
      // totalCount: totalRecords,
    )).toList();

    // 아티스트 분석
    var artistGroups = <String, int>{};
    for (var record in records) {
      artistGroups[record.artist] = (artistGroups[record.artist] ?? 0) + 1;
    }
    var mostCollectedArtist = artistGroups.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    // 연도별 분석
    var decadeGroups = <String, int>{};
    for (var record in records.where((r) => r.releaseYear != null)) {
      String decade = "\${(record.releaseYear! ~/ 10) * 10}년대";
      decadeGroups[decade] = (decadeGroups[decade] ?? 0) + 1;
    }
    var decades = decadeGroups.entries.map((entry) => DecadeAnalytics(
      decade: entry.key,
      count: entry.value,
      // totalCount: totalRecords,
    )).toList();

    // 가장 많이 수집된 장르
    var mostCollectedGenre = genres.where((g) => g.name != "기타").reduce((a, b) => a.count > b.count ? a : b).name;

    // 가장 오래된/최신 레코드
    var oldestRecord = records.map((r) => r.releaseYear ?? 0).reduce((a, b) => a < b ? a : b);
    var newestRecord = records.map((r) => r.releaseYear ?? 0).reduce((a, b) => a > b ? a : b);

    analytics = CollectionAnalytics(
      totalRecords: totalRecords,
      genres: genres,
      decades: decades,
      mostCollectedGenre: mostCollectedGenre,
      mostCollectedArtist: mostCollectedArtist,
      oldestRecord: oldestRecord,
      newestRecord: newestRecord,
    );
    notifyListeners();
  }
}
