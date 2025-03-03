import 'dart:io';

abstract class AlbumRecognitionRepository {
  Future<String?> recognizeAlbumLabel(File image);
}
