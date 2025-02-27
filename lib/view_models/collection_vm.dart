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
      'ya29.a0AeXRPp5xyrJu9wc9Bt6E5Z_wPdoHVCnL9IOIg7SdGAANp8ORNg68tRRc5QieVjwuGQxtKMFoXPX-LGNO_fklFMMQJV9W9JCBcoa1k0xFMEh7fwyUykDF8DdN-V5k0z445XhatBNs0EjNx9ueQymWGvXkB9t-rSlHOWY5XbNcfUOBQn0aCgYKAUISARESFQHGX2MibKUaAMpW9VsPmt6-II38Pg0182';

  // Vision API로부터 가져온 라벨
  String? _lastRecognizedLabel;

  String? get lastRecognizedLabel => _lastRecognizedLabel;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<DiscogsRecord> _searchResults = [];

  List<DiscogsRecord> get searchResults => _searchResults;

  // Private backing field
  List<DiscogsRecord> _collectionRecords = [];

  // Public getter
  List<DiscogsRecord> get collectionRecords => _collectionRecords;

  // Public setter (옵션에 따라 필요 시 정의)
  set collectionRecords(List<DiscogsRecord> records) {
    _collectionRecords = records;
    notifyListeners();
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

  Future<void> addToCollection(
    DiscogsRecord record,
    String condition,
    String conditionNotes,
    double purchasePrice,
  ) async {
    _isAdding = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('로그인이 필요합니다.');
      }

      // user_collections 테이블 구조에 맞춰 insert
      final insertData = {
        'record_id': record.id.toInt(),
        'condition': condition,
        'condition_notes': conditionNotes,
        'purchase_price': purchasePrice,
        'notes': record.notes ?? '', // DiscogsRecord notes
      };

      try {
        await addDiscogsRecordToDB(record);
      } catch (e) {
        print('Error adding Discogs record: $e');
      }

      // 추가로 purchase_date 같은 게 필요하다면, 아래처럼:
      // insertData['purchase_date'] = DateTime.now().toIso8601String();

      final response = await supabase
          .from('user_collections')
          .insert(insertData)
          .maybeSingle(); // v1.x API

      // response가 null이면 row가 없거나, 에러면 예외 발생
      // supabase_flutter >=1.0은 에러 발생 시 바로 예외 throw
    } catch (e) {
      _errorMessage = '컬렉션 추가 실패: $e';
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
          'Authorization': "Bearer " + _googleVisionApiKey,
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
      updateAllRecordsAsync(results);
      _searchResults = results;
    } catch (e) {
      _errorMessage = 'Discogs 검색 오류: $e';
    }
  }

  Future<void> addDiscogsRecordToDB(DiscogsRecord record) async {
    try {
      // Supabase insert
      final response = await supabase
          .from('records')
          .insert(record.toJson())
          .single(); // single() → 단일 row 반환

      print('Record inserted successfully: $response');
    } catch (e) {
      print('Error inserting record: $e');
      rethrow; // 필요하면 에러를 상위로 던짐
    }
  }

  // 예: 여러 작업을 병렬 처리하고, 전부 완료되면 로그만 남기는 예시
  Future<void> updateAllRecordsAsync(List<DiscogsRecord> records) async {
    final supabase = Supabase.instance.client;

    // 병렬 실행을 위한 Future 리스트
    final futures = <Future>[];

    for (final r in records) {
      futures.add(
          supabase.from('records').upsert(r.toJson())
      );
    }

    await Future.wait(futures)
        .then((_) => debugPrint('All upserts completed.'))
        .catchError((error) => debugPrint('Some upsert failed: $error'));
  }

  Future<void> fetchUserCollectionsWithRecords() async {
    _isLoading = true;
    notifyListeners();

    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      print('User is not logged in.');
      return;
    }

    final response = await supabase
        .from('user_collections')
        .select('*, records(*)')
        .eq('user_id', userId.toString());

    debugPrint("response: $response");

    // collectionRecords setter를 통해 데이터 할당
    collectionRecords = response.map<DiscogsRecord>((item) {
      final recordJson = item['records'] as Map<String, dynamic>?;
      // record_id를 id로 변경
      recordJson?['id'] = item['record_id'];
      if (recordJson != null) {
        return DiscogsRecord.fromJson(recordJson);
      } else {
        debugPrint('Record not found for item: $item');
        return DiscogsRecord.sampleData[0];
      }
    }).toList();
    _isLoading = false;
    notifyListeners();
  }

  void analyzeCollection() {
    final records = _collectionRecords;
    int totalRecords = records.length;

    // 1. 장르별 집계 (예: 각 레코드의 첫 번째 장르 기준)
    Map<String, int> genreCounts = {};
    for (final record in records) {
      if (record.genres.isNotEmpty) {
        String genre = record.genres[0];
        genreCounts[genre] = (genreCounts[genre] ?? 0) + 1;
      }
    }
    String mostCollectedGenre = genreCounts.isNotEmpty
        ? genreCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key
        : '';

    // 2. 아티스트별 집계 (예: 각 레코드의 첫 번째 아티스트 기준)
    Map<String, int> artistCounts = {};
    for (final record in records) {
      if (record.artists.isNotEmpty) {
        String artistName = record.artists[0].name;
        artistCounts[artistName] = (artistCounts[artistName] ?? 0) + 1;
      }
    }
    String mostCollectedArtist = artistCounts.isNotEmpty
        ? artistCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key
        : '';

    // 3. 연대별 집계 (releaseYear 값 기준)
    Map<String, int> decadeCounts = {};
    for (final record in records) {
      if (record.year > 0) {
        int decadeStart = (record.year ~/ 10) * 10;
        String decadeLabel = "${decadeStart}'s";
        decadeCounts[decadeLabel] = (decadeCounts[decadeLabel] ?? 0) + 1;
      }
    }

    // 4. 가장 오래된/최신 연도 계산
    int oldestRecord = records.isNotEmpty
        ? records.map((r) => r.year ?? 0).reduce((a, b) => a < b ? a : b)
        : 0;
    int newestRecord = records.isNotEmpty
        ? records.map((r) => r.year ?? 0).reduce((a, b) => a > b ? a : b)
        : 0;

    // 5. CollectionAnalytics 객체 생성 (모델 생성자는 상황에 맞게 정의)
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
          .map((entry) => DecadeAnalytics(decade: entry.key, count: entry.value))
          .toList(),
    );
    notifyListeners();
  }
}
