import 'package:flutter/cupertino.dart';
import '../data/models/discogs_record.dart' as data;
import '../domain/repositories/collection_repository.dart';
import '../domain/usecases/search_artist.dart';
import '../domain/usecases/search_by_id_data.dart';
import '../model/local/collection_record.dart';
import '../model/supabase/user_collection.dart';

class RecordDetailsViewModel extends ChangeNotifier {
  final CollectionRepository collectionRepository;
  final SearchByIdData searchById;
  final SearchArtist searchArtist;

  RecordDetailsViewModel(
      this.collectionRepository, this.searchArtist, this.searchById);

  late CollectionRecord _collectionRecord;
  data.DiscogsRecord? _modelRecord;

  bool _isAdding = false;
  bool _isLoading = false;
  String? _errorMessage;

  // Getter methods
  CollectionRecord get collectionRecord => _collectionRecord;

  data.DiscogsRecord? get entityRecord => _modelRecord;

  bool get isAdding => _isAdding;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  // Setter for collectionRecord; 초기화 후 상세정보를 가져옵니다.
  set collectionRecord(CollectionRecord record) {
    _collectionRecord = record;
    _fetchRecordDetails();
    notifyListeners();
  }

  // URL에서 releaseId를 추출하는 헬퍼 메서드
  int _extractReleaseId(String url) {
    return int.parse(url.split("/").last);
  }

  // 레코드 상세 정보를 비동기로 가져오는 메서드
  Future<void> _fetchRecordDetails() async {
    _setLoading(true);
    try {
      final releaseId = _extractReleaseId(_collectionRecord.record.resourceUrl);
      _modelRecord = await searchById.call(releaseId);
      debugPrint("DiscogsRecord: ${_modelRecord?.toJson()}");
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // 레코드 업데이트
  Future<void> updateRecord(UserCollection record) async {
    try {
      await collectionRepository.update(record);
      debugPrint("Record updated: ${record.toJson()}");
    } catch (e) {
      debugPrint('Error in updateRecord: $e');
    }
  }

  Future<void> getRecordDetails() async {
    try {
      _setLoading(true);
      final releaseId = int.parse(_collectionRecord.record.resourceUrl.split("/").last);
      _modelRecord = await searchById.call(releaseId);
      debugPrint("List<DiscogsSearchItem>: ${_modelRecord?.toJson()}");
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // 상태 업데이트를 위한 헬퍼 메서드들
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // 에러 메시지 설정
  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }
}
