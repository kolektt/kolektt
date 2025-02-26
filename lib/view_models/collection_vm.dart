import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kolektt/model/recognition.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/collection_analytics.dart';
import '../model/decade_analytics.dart';
import '../model/discogs_record.dart';
import '../model/genre_analytics.dart';
import '../model/record.dart';
import '../services/discogs_api_service.dart';

class CollectionViewModel extends ChangeNotifier {
  File? selectedImage;
  RecognitionResult? recognitionResult;
  CollectionAnalytics? analytics;

  final SupabaseClient supabase = Supabase.instance.client;
  bool _isAdding = false;

  bool get isAdding => _isAdding;
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  // 구글 비전 API 키 (보안을 위해 .env나 서버에서 관리 권장)
  static const String _googleVisionApiKey =
      'Bearer ya29.a0AeXRPp6vf2j2uxW2XxfElEQTR6zP9bf82E8dc9F7j0zowgZ5hl47wJQCan8vSiVfPHHNtpoby9rR8JfKnk6waPLVQFqP5URrSZYKhV66rz_zKGSg4ReEbr9TqI26Eg4LwBAWNofj8YBD4X4Xh-hY11bflFVz-0L3RUQSGMIVncq21waCgYKAf4SARESFQHGX2Mi2bwYhn5S-Nr6WFkDrzV3nw0181';

  // Vision API로부터 가져온 라벨
  String? _lastRecognizedLabel;

  String? get lastRecognizedLabel => _lastRecognizedLabel;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<DiscogsRecord> _searchResults = [];

  List<DiscogsRecord> get searchResults => _searchResults;

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

  Future<void> addToCollection(DiscogsRecord record) async {
    _isAdding = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await supabase.from('user_collections').insert({
        'record_id': record.id.toString(),
        'title': record.title,
        'artist': record.artists.isNotEmpty ? record.artists[0].name : '',
        'release_year': record.year,
        'cover_image': record.coverImage,
        'catalog_number':
            record.labels.isNotEmpty ? record.labels[0].catno : '',
        'label': record.labels.isNotEmpty ? record.labels[0].name : '',
        'format': record.formats.isNotEmpty ? record.formats[0].text : '',
        'country': record.country,
        'style': record.styles.isNotEmpty ? record.styles.join(', ') : '',
        'notes': record.notes,
      });

      if (response.error != null) {
        throw Exception(response.error!.message);
      }

      notifyListeners();
    } catch (e) {
      _errorMessage = '컬렉션 추가 실패: $e';
      notifyListeners();
    } finally {
      _isAdding = false;
      notifyListeners();
    }
  }

  /// 1) Google Vision API로 앨범 라벨 인식 → 2) Discogs 검색
  Future<void> recognizeAlbum(File image) async {
    _isLoading = true;
    _errorMessage = null;
    _searchResults = [];
    notifyListeners();

    try {
      final base64Image = base64Encode(await image.readAsBytes());
      final url = Uri.parse('https://vision.googleapis.com/v1/images:annotate');

      // Google Vision API 요청 바디
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

      // Vision API 호출
      final response = await http.post(
        url,
        headers: {
          'Authorization': _googleVisionApiKey,
          'x-goog-user-project': 'kolektt',
          'Content-Type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(requestBody),
      );

      debugPrint('Google Vision API Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final bestGuessLabels =
            data['responses']?[0]?['webDetection']?['bestGuessLabels'];

        if (bestGuessLabels != null && bestGuessLabels.isNotEmpty) {
          _lastRecognizedLabel = bestGuessLabels.first['label'] as String?;
          // Discogs 검색
          await _searchOnDiscogs(_lastRecognizedLabel ?? '');
        } else {
          _errorMessage = '앨범 라벨을 인식하지 못했습니다.';
        }
      } else {
        _errorMessage =
            'Google Vision API 호출 실패 (Status: ${response.statusCode})';
      }
    } catch (e) {
      _errorMessage = '네트워크 오류: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Discogs API로 검색
  Future<void> _searchOnDiscogs(String query) async {
    if (query.isEmpty) return;
    try {
      final discogsApi = DiscogsApiService();
      final results = await discogsApi.searchDiscogs(query, type: 'release');
      _searchResults = results;
    } catch (e) {
      _errorMessage = 'Discogs 검색 오류: $e';
    }
  }
}
