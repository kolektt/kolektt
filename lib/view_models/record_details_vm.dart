import 'package:flutter/cupertino.dart';

import '../data/models/discogs_record.dart' as data;
import '../domain/usecases/search_artist.dart';
import '../domain/usecases/search_by_id_data.dart';
import '../model/local/collection_record.dart';

class RecordDetailsViewModel extends ChangeNotifier {
  final SearchByIdData searchById;
  final SearchArtist searchArtist;

  RecordDetailsViewModel(this.searchArtist, this.searchById);

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
}
