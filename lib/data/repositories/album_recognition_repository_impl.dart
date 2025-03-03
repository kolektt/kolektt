// data/repositories/album_recognition_repository_impl.dart
import 'dart:io';

import '../../domain/repositories/album_recognition_repository.dart';
import '../datasources/google_vision_data_source.dart';

class AlbumRecognitionRepositoryImpl implements AlbumRecognitionRepository {
  final GoogleVisionDataSource dataSource;

  AlbumRecognitionRepositoryImpl({required this.dataSource});

  Future<String?> recognizeAlbumLabel(File image) async {
    return await dataSource.recognizeAlbumLabel(image);
  }
}
