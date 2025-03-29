import 'dart:io';

abstract class IStorageRepository {
  Future<String> uploadImage(File image);
}
