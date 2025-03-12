// data/repositories/album_recognition_repository_impl.dart
import 'dart:io';

import '../../domain/entities/album_recognition_result.dart';
import '../../domain/repositories/album_recognition_repository.dart';
import '../datasources/google_vision_data_source.dart';

class AlbumRecognitionRepositoryImpl implements AlbumRecognitionRepository {
  final GoogleVisionDataSource dataSource;

  AlbumRecognitionRepositoryImpl({required this.dataSource});

  @override
  Future<AlbumRecognitionResult> analyzeAlbumCover(File image) async {
    final result = await dataSource.analyzeAlbumCover(image);
    return AlbumRecognitionResult(
      bestGuessLabel: result['bestGuessLabel'],
      partialMatchingImages: result['partialMatchingImages'] ?? [],
    );
  }
}
