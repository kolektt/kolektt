import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'package:kolektt/model/local/collection_record.dart';
import 'package:kolektt/model/recognition.dart';
import 'package:kolektt/model/supabase/user_collection.dart';
import 'package:kolektt/repository/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/models/discogs_search_response.dart';
import '../data/models/user_collection_classification.dart';
import '../domain/repositories/album_recognition_repository.dart';
import '../domain/repositories/collection_repository.dart';
import '../domain/repositories/discogs_record_repository.dart';
import '../domain/repositories/discogs_repository.dart';
import '../domain/usecases/search_and_upsert_discogs_records.dart';
import '../model/collection_analytics.dart';
import '../model/local/collection_classification.dart'; // classifyCollections 함수와 CollectionClassification 클래스 포함

class CollectionViewModel extends ChangeNotifier {
  final SearchAndUpsertDiscogsRecords searchAndUpsertUseCase;
  CollectionRepository collectionRepository;
  AlbumRecognitionRepository albumRecognitionRepository;
  ProfileRepository _profileRepository = ProfileRepository();
  DiscogsRecordRepository discogsRecordRepository;

  File? selectedImage;
  RecognitionResult? recognitionResult;
  CollectionAnalytics? analytics;

  UserCollectionClassification _userCollectionClassification = UserCollectionClassification.initial();

  UserCollectionClassification get userCollectionClassification => _userCollectionClassification;

  set userCollectionClassification(UserCollectionClassification classification) {
    _userCollectionClassification = classification;
    notifyListeners();
  }

  final SupabaseClient supabase = Supabase.instance.client;
  bool _isAdding = false;

  bool get isAdding => _isAdding;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  set errorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  // Vision API로부터 가져온 라벨
  String? _lastRecognizedLabel;

  String? get lastRecognizedLabel => _lastRecognizedLabel;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<DiscogsSearchItem> _searchResults = [];

  List<DiscogsSearchItem> get searchResults => _searchResults;

  List<String> _partialMatchingImages = [];

  List<String> get partialMatchingImages => _partialMatchingImages;

  // Private backing field
  List<CollectionRecord> _collectionRecords = [];

  // Public getter
  List<CollectionRecord> get collectionRecords => _collectionRecords;

  // Public setter (컬렉션 업데이트 시 notifyListeners)
  set collectionRecords(List<CollectionRecord> records) {
    _collectionRecords = records;
    notifyListeners();
  }

  String get userId => _profileRepository.getCurrentUserId();

  // 분류 결과 (장르/레이블/아티스트)
  CollectionClassification? classification;

  CollectionViewModel({
    required SearchAndUpsertDiscogsRecords this.searchAndUpsertUseCase,
    required DiscogsRepository discogs_repository,
    required CollectionRepository this.collectionRepository,
    required AlbumRecognitionRepository this.albumRecognitionRepository,
    required DiscogsRecordRepository this.discogsRecordRepository,
  });

  Future<void> addToCollection(
      DiscogsSearchItem record,
      String condition,
      double purchasePrice,
      DateTime purchaseDate,
      List<String> _tagList,
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
        'purchase_price': purchasePrice,
        'purchase_date': purchaseDate.toIso8601String(),
        'tags': _tagList,
      };

      try {
        await addDiscogsRecordToDB(record);
        print('Discogs record added successfully.');
      } catch (e) {
        print('Error adding Discogs record: $e');
      }

      await collectionRepository.insertUserCollection(insertData);
    } catch (e) {
      _errorMessage = '컬렉션 추가 실패: $e';
    } finally {
      _isAdding = false;
      notifyListeners();
    }
  }

  Future<void> removeRecord(CollectionRecord record) async {
    try {
      collectionRepository.deleteUserCollection(record.user_collection.id);
      _collectionRecords.removeWhere((r) => r.user_collection.id == record.user_collection.id);
      notifyListeners();
      debugPrint('Record removed successfully.');
    } catch (e) {
      debugPrint('Error in removeRecord: $e');
    }
  }

  /// 1) Google Vision API로 앨범 라벨 인식 → 2) Discogs 검색
  Future<void> recognizeAlbum(File image) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. 이미지 업로드 및 URL 획득
      final imageUrl = await _uploadImageToSupabase(image);
      if (imageUrl.isEmpty) throw Exception("이미지 업로드 실패");

      // 2. lens API 호출
      final lensResponse = await _fetchLensData(imageUrl);
      if (lensResponse == null) throw Exception("lens API 호출 실패");

      // 3. 응답에서 title 추출
      final List<String> titles = _extractTitlesFromLensResponse(lensResponse);
      if (titles.isEmpty) throw Exception("검색 결과에서 title 추출 실패");

      // 4. Gemini API에 title 리스트를 전달하여 최종 앨범 키워드 생성
      final generatedLabel = await _generateLabelWithGemini(titles);
      if (generatedLabel.isEmpty) throw Exception("Gemini 응답 없음");

      // 5. 최종 라벨 저장 (여기서 _lastRecognizedLabel에 할당)
      _lastRecognizedLabel = generatedLabel;

      // Gemini 결과로 Discogs 검색을 실행합니다.
      await searchOnDiscogs(generatedLabel);
    } catch (e) {
      _errorMessage = '앨범 인식 중 오류 발생: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 1. Supabase Storage에 이미지 업로드 후 공개 URL을 반환
  Future<String> _uploadImageToSupabase(File image) async {
    try {
      // 예시: "album-images" 버킷에 업로드
      final fileName = 'uploads/${DateTime.now().millisecondsSinceEpoch}.jpg';
      await supabase.storage.from('album-images').upload(fileName, image);
      // 업로드가 성공하면 URL을 생성 (버킷 공개 설정이 필요)
      final publicUrl = supabase.storage.from('album-images').getPublicUrl(fileName);
      return publicUrl;
    } catch (e) {
      debugPrint("Supabase 업로드 오류: $e");
      return "";
    }
  }

  /// 2. lens API 호출 (imageUrl을 파라미터로 전달)
  Future<Map<String, dynamic>?> _fetchLensData(String imageUrl) async {
    const lensEndpoint = 'https://google.serper.dev/lens';
    const apiKey = 'a0d1958a5a5f4e93977da141b8af978b1cd2f1b8';

    final headers = {
      'X-API-KEY': apiKey,
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      "url": imageUrl,
      "gl": "kr",
      "hl": "ko"
    });

    try {
      final response = await http.post(Uri.parse(lensEndpoint), headers: headers, body: body);
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        debugPrint("lens API 응답 에러: ${response.statusCode} ${response.reasonPhrase}");
        return null;
      }
    } catch (e) {
      debugPrint("lens API 호출 중 예외 발생: $e");
      return null;
    }
  }

  /// 3. lens API 응답에서 organic 배열의 title 값들만 추출
  List<String> _extractTitlesFromLensResponse(Map<String, dynamic> responseJson) {
    List<String> titles = [];
    if (responseJson.containsKey("organic") && responseJson["organic"] is List) {
      for (var item in responseJson["organic"]) {
        if (item is Map<String, dynamic> && item.containsKey("title")) {
          titles.add(item["title"].toString());
        }
      }
    }
    return titles;
  }

  /// 4. Gemini API 호출하여 title 리스트를 기반으로 앨범 검색 키워드 생성
  Future<String> _generateLabelWithGemini(List<String> titles) async {
    // Gemini API Key는 환경변수 또는 안전한 저장소에 보관
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) {
      debugPrint('GEMINI_API_KEY 환경변수가 설정되어 있지 않습니다.');
      return "";
    }

    // Gemini 모델 설정 (예시: gemini-2.0-flash)
    final model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 1,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 8192,
        responseMimeType: 'text/plain',
      ),
      systemInstruction: Content.system(
          '다음 리스트에서 문자열들을 분석하여 가장 적절한 앨범 검색 키워드 하나를 제시해주세요. '
              '관련된 앨범 이름이 있다면 우선적으로 고려하고, 없다면 가장 관련성이 높은 단어를 조합하여 키워드를 생성합니다.\n\n'
              '리스트:\n\n${jsonEncode(titles)}\n\n기대 출력:\n\n앨범 이름'),
    );

    // 기존에 사용하던 빈 TextPart를 제거하여 빈 텍스트 전송 문제를 방지합니다.
    final chat = model.startChat(history: [
      Content.multi([
        TextPart('${jsonEncode(titles)}'),
      ]),
    ]);

    final message = '분석 후 앨범 키워드를 알려주세요.';
    final content = Content.text(message);

    try {
      final response = await chat.sendMessage(content);
      debugPrint("Gemini 응답: ${response.text}");
      return response.text!.trim();
    } catch (e) {
      debugPrint("Gemini API 호출 오류: $e");
      return "";
    }
  }

  /// Discogs API로 검색
  Future<void> searchOnDiscogs(String query) async {
    if (query.isEmpty) return;
    try {
      final results = await searchAndUpsertUseCase.call(query, type: 'release');
      _searchResults = results;
    } catch (e) {
      _errorMessage = 'Discogs 검색 오류: $e';
    } finally {
      notifyListeners();
    }
  }

  Future<void> addDiscogsRecordToDB(DiscogsSearchItem record) async {
    try {
      await discogsRecordRepository.addDiscogsRecord(record);
      print('Discogs record added successfully.');
    } catch (e) {
      log('Error inserting record: $e');
      rethrow;
    }
  }

  Future<void> fetch() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _fetchUserCollectionsWithRecords();
      await _fetchUserCollectionsUniqueProperties();
    } catch (e) {
      _errorMessage = '컬렉션을 불러오는 중 오류가 발생했습니다: $e';
      debugPrint('Error fetching user collection: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> reset() async {
    _collectionRecords = [];
    _userCollectionClassification = _userCollectionClassification.copyWith(
      mediaCondition: "All",
      sleeveCondition: "All",
      genre: 'All',
      startYear: 1900,
      endYear: 2025,
      sortOption: '최신순',
    );
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  /// 컬렉션을 불러온 후, CollectionClassification 함수를 호출하여 분류 결과를 저장합니다.
  Future<void> _fetchUserCollectionsWithRecords() async {
    _isLoading = true;
    notifyListeners();

    try {
      collectionRecords = await collectionRepository.fetchUserCollection(userId);
      classification = classifyCollections(collectionRecords);
    } catch (e) {
      _errorMessage = '컬렉션을 불러오는 중 오류가 발생했습니다: $e';
      debugPrint('Error fetching user collection: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchUserCollectionsUniqueProperties() async {
    try {
      _isLoading = true;
      notifyListeners();

      _userCollectionClassification = await collectionRepository.fetchUniqueProperties(userId);
      debugPrint('UserCollectionClassification: ${_userCollectionClassification.genres}, mediaCondition: ${_userCollectionClassification.mediaCondition}');
    } catch (e) {
      _errorMessage = '컬렉션을 불러오는 중 오류가 발생했습니다: $e';
      debugPrint('Error fetching user collection: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> filterCollection() async {
    try {
      _isLoading = true;
      notifyListeners();

      _collectionRecords = await collectionRepository.filterUserCollection(userId, _userCollectionClassification);

      for (var record in _collectionRecords) {
        debugPrint('Filtered record: ${record.record.title}');
      }
    } catch (e) {
      _errorMessage = '컬렉션 필터링 중 오류가 발생했습니다: $e';
      debugPrint('Error filtering user collection: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
