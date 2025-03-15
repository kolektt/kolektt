import 'dart:core';

import 'package:flutter/material.dart';

import '../model/article.dart';
import '../model/article_content.dart';
import '../model/article_content_type.dart';
import '../model/dj_pick.dart';
import '../model/local/collection_record.dart';
import '../model/music_taste.dart';
import '../model/popular_record.dart';
import '../model/record.dart';
import '../model/record_shop.dart';

/// Flutter의 HomeViewModel (ChangeNotifier 기반)
class HomeViewModel extends ChangeNotifier {
  // Private backing field
  List<CollectionRecord> _collectionRecords = [];

  // Public getter
  List<CollectionRecord> get collectionRecords => _collectionRecords;

  set collectionRecords(List<CollectionRecord> records) {
    _collectionRecords = records;
    notifyListeners();
  }

  HomeViewModel() {
  }
}
