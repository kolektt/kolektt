import 'dart:io';

import '../entities/album_recognition_result.dart';

abstract class AlbumRecognitionRepository {
  Future<AlbumRecognitionResult> analyzeAlbumCover(File image);
}
