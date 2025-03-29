import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/models/discogs_search_response.dart';
import '../domain/repositories/collection_repository.dart';
import '../domain/repositories/discogs_record_repository.dart';

class AddCollectionViewModel extends ChangeNotifier {
  CollectionRepository collectionRepository;
  DiscogsRecordRepository discogsRecordRepository;

  AddCollectionViewModel({
    required this.collectionRepository,
    required this.discogsRecordRepository,
  });

  final SupabaseClient _supabase = Supabase.instance.client;

  bool _isAdding = false;

  bool get isAdding => _isAdding;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  set isAdding(bool value) {
    _isAdding = value;
    notifyListeners();
  }

  set errorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> addToCollection(
    DiscogsSearchItem record,
    String condition,
    String note,
    double purchasePrice,
    DateTime purchaseDate,
    List<String> _tagList,
  ) async {
    _isAdding = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('로그인이 필요합니다.');
      }

      // user_collections 테이블 구조에 맞춰 insert
      final insertData = {
        'record_id': record.id.toInt(),
        'condition': condition,
        'purchase_price': purchasePrice,
        'purchase_date': purchaseDate.toIso8601String(),
        'notes': note,
        'tags': _tagList,
      };

      try {
        await _addDiscogsRecordToDB(record);
        print('Discogs record added successfully.');
      } catch (e) {
        print('Error adding Discogs record: $e');
      }

      await collectionRepository.insert(insertData);
    } catch (e) {
      _errorMessage = '컬렉션 추가 실패: $e';
    } finally {
      _isAdding = false;
      notifyListeners();
    }
  }

  Future<void> _addDiscogsRecordToDB(DiscogsSearchItem record) async {
    try {
      await discogsRecordRepository.addDiscogsRecord(record);
      print('Discogs record added successfully.');
    } catch (e) {
      log('Error inserting record: $e');
      rethrow;
    }
  }
}
