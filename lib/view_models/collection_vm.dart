import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kolektt/model/local/collection_record.dart';
import 'package:kolektt/model/recognition.dart';
import 'package:kolektt/model/supabase/user_collection.dart';
import 'package:kolektt/repository/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../components/filter_cupertino_sheet.dart';
import '../data/models/discogs_search_response.dart';
import '../data/models/user_collection_classification.dart';
import '../domain/repositories/album_recognition_repository.dart';
import '../domain/repositories/collection_repositroy.dart';
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

  late UserCollectionClassification _userCollectionClassification;

  UserCollectionClassification get userCollectionClassification => _userCollectionClassification;

  final SupabaseClient supabase = Supabase.instance.client;
  bool _isAdding = false;

  bool get isAdding => _isAdding;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  // Vision API로부터 가져온 라벨
  String? _lastRecognizedLabel;

  String? get lastRecognizedLabel => _lastRecognizedLabel;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<DiscogsSearchItem> _searchResults = [];

  List<DiscogsSearchItem> get searchResults => _searchResults;

  // Private backing field
  List<CollectionRecord> _collectionRecords = [];

  // Public getter
  List<CollectionRecord> get collectionRecords => _collectionRecords;

  // Public setter (컬렉션 업데이트 시 notifyListeners)
  set collectionRecords(List<CollectionRecord> records) {
    _collectionRecords = records;
    notifyListeners();
  }

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

  Future<void> updateRecord(UserCollection record) async {
    try {
      await collectionRepository.updateUserCollection(record);
      debugPrint("Record: ${record.toJson()}");
    } catch (e) {
      debugPrint('Error in updateRecord: $e');
    }
  }

  /// 1) Google Vision API로 앨범 라벨 인식 → 2) Discogs 검색
  Future<void> recognizeAlbum(File image) async {
    _isLoading = true;
    _errorMessage = null;
    _searchResults = [];
    notifyListeners();

    try {
      final label = await albumRecognitionRepository.recognizeAlbumLabel(image);
      if (label != null && label.isNotEmpty) {
        _lastRecognizedLabel = label;
        await _searchOnDiscogs(label);
      } else {
        _errorMessage = '앨범 라벨을 인식하지 못했습니다.';
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
      final results = await searchAndUpsertUseCase.call(query, type: 'release');
      _searchResults = results;
    } catch (e) {
      _errorMessage = 'Discogs 검색 오류: $e';
    }
  }

  Future<void> addDiscogsRecordToDB(DiscogsSearchItem record) async {
    try {
      // TODO: DiscogsSearchItem → Record 변환
      await discogsRecordRepository.addDiscogsRecord(record);
    } catch (e) {
      log('Error inserting record: $e');
      rethrow;
    }
  }

  /// 컬렉션을 불러온 후, CollectionClassification 함수를 호출하여 분류 결과를 저장합니다.
  Future<void> fetchUserCollectionsWithRecords() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userId = _profileRepository.getCurrentUserId();
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

  Future<void> fetchUserCollectionsUniqueProperties() async {
    try {
      _isLoading = true;
      notifyListeners();

      final userId = _profileRepository.getCurrentUserId();
      _userCollectionClassification = await collectionRepository.fetchUniqueProperties(userId);
    } catch (e) {
      _errorMessage = '컬렉션을 불러오는 중 오류가 발생했습니다: $e';
      debugPrint('Error fetching user collection: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    /// 컬렉션 데이터가 변경되었을 때 분류 결과를 업데이트합니다.
    void updateClassification() {
      classification = classifyCollections(_collectionRecords);
      notifyListeners();
    }
  }

  Future<void> filterCollection(UserCollectionClassification classification) async {
    try {
      _isLoading = true;
      notifyListeners();

      final userId = _profileRepository.getCurrentUserId();
      _collectionRecords = await collectionRepository.filterUserCollection(userId, classification);

      if (!kDebugMode) return;
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
