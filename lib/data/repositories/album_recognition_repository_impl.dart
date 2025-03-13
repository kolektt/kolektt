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
    final webDetectFuture = dataSource.analyzeAlbumCover(image); // Future<Map<String, dynamic>>
    final textDetectFuture = dataSource.analyzeTextDetection(image); // Future<String?>

    final results = await Future.wait([webDetectFuture, textDetectFuture]);
    final webDetectResult = results[0] as Map<String, dynamic>;
    final textDetectResult = results[1] as String?;

    return AlbumRecognitionResult(
      bestGuessLabel: webDetectResult['bestGuessLabel'] as String?,
      partialMatchingImages: (webDetectResult['partialMatchingImages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
          [],
      fullDetectedText: textDetectResult,
    );
  }
}
