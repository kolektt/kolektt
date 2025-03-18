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

  RecordDetailsViewModel(this.collectionRepository, this.searchArtist, this.searchById);

  late CollectionRecord _collectionRecord;

  CollectionRecord get collectionRecord => _collectionRecord;

  set collectionRecord(CollectionRecord record) {
    _collectionRecord = record;
    getRecordDetails();
    notifyListeners();
  }

  late data.DiscogsRecord _modelRecord;

  data.DiscogsRecord get entityRecord => _modelRecord;

  bool _isAdding = false;

  bool get isAdding => _isAdding;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  set errorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  Future<void> getRecordDetails() async {
    try {
      isLoading = true;
      final releaseId = int.parse(_collectionRecord.record.resourceUrl.split("/").last);
      _modelRecord = await searchById.call(releaseId);
      print("List<DiscogsSearchItem>: ${_modelRecord.toJson()}");
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
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
}
