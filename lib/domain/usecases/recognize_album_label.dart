import 'dart:io';

import '../entities/album_recognition_result.dart';
import '../repositories/album_recognition_repository.dart';

class RecognizeAlbumLabel {
  AlbumRecognitionRepository repository;

  RecognizeAlbumLabel(this.repository);

  Future<AlbumRecognitionResult> call(File image) async {
    return await repository.recognizeAlbumLabel(image);
  }
}
