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
import 'package:kolektt/repository/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/models/discogs_search_response.dart';
import '../data/models/user_collection_classification.dart';
import '../domain/entities/album_recognition_result.dart';
import '../domain/repositories/album_recognition_repository.dart';
import '../domain/repositories/collection_repository.dart';
import '../domain/repositories/discogs_record_repository.dart';
import '../domain/repositories/discogs_repository.dart';
import '../domain/usecases/recognize_album.dart';
import '../domain/usecases/search_and_upsert_discogs_records.dart';
import '../model/collection_analytics.dart';
import '../model/local/collection_classification.dart'; // classifyCollections 함수와 CollectionClassification 클래스 포함

class CollectionViewModel extends ChangeNotifier {
  final SearchAndUpsertDiscogsRecords searchAndUpsertUseCase;

  final RecognizeAlbumUseCase recognizeAlbumUseCase;

  CollectionRepository collectionRepository;
  AlbumRecognitionRepository albumRecognitionRepository;
  ProfileRepository _profileRepository = ProfileRepository();
  DiscogsRecordRepository discogsRecordRepository;

  File? selectedImage;
  RecognitionResult? recognitionResult;
  CollectionAnalytics? analytics;

  AlbumRecognitionResult? _albumRecognitionResult;

  AlbumRecognitionResult? get albumRecognitionResult => _albumRecognitionResult;

  UserCollectionClassification _userCollectionClassification =
      UserCollectionClassification.initial();

  UserCollectionClassification get userCollectionClassification =>
      _userCollectionClassification;

  set userCollectionClassification(
      UserCollectionClassification classification) {
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
    required this.recognizeAlbumUseCase,
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
      _collectionRecords.removeWhere(
          (r) => r.user_collection.id == record.user_collection.id);
      notifyListeners();
      debugPrint('Record removed successfully.');
    } catch (e) {
      debugPrint('Error in removeRecord: $e');
    }
  }

  /// 앨범 인식을 실행하고, 인식된 키워드로 Discogs 검색을 수행합니다.
  Future<void> recognizeAlbum(File image) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. 도메인 Use Case를 통해 앨범 인식 실행
      final result = await recognizeAlbumUseCase.execute(image);
      _albumRecognitionResult = result;
      // 2. 인식된 키워드를 기반으로 Discogs 검색 실행
      if (result.bestGuessLabel == null) {
        _errorMessage = '앨범 인식 실패: ${_errorMessage}';
        return;
      }
      await searchOnDiscogs(result.bestGuessLabel!);
    } catch (e) {
      _errorMessage = '앨범 인식 중 오류 발생: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
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
      collectionRecords =
          await collectionRepository.fetchUserCollection(userId);
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

      _userCollectionClassification =
          await collectionRepository.fetchUniqueProperties(userId);
      debugPrint(
          'UserCollectionClassification: ${_userCollectionClassification.genres}, mediaCondition: ${_userCollectionClassification.mediaCondition}');
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

      _collectionRecords = await collectionRepository.filterUserCollection(
          userId, _userCollectionClassification);

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
