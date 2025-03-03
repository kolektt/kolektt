// data/repositories/album_recognition_repository.dart
import 'dart:io';

import '../datasources/google_vision_data_source.dart';

class AlbumRecognitionRepository {
  final GoogleVisionDataSource dataSource;

  AlbumRecognitionRepository({required this.dataSource});

  Future<String?> recognizeAlbumLabel(File image) async {
    return await dataSource.recognizeAlbumLabel(image);
  }
}
