import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer';

import '../../domain/repositories/storage_repository.dart';

/// Supabase Storage 구현
class SupabaseStorageRepository implements IStorageRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Future<String> uploadImage(File image) async {
    try {
      final fileName = 'uploads/${DateTime.now().millisecondsSinceEpoch}.jpg';
      await supabase.storage.from('album-images').upload(fileName, image);
      final publicUrl = supabase.storage.from('album-images').getPublicUrl(fileName);
      return publicUrl;
    } catch (e) {
      log("Supabase 업로드 오류: $e");
      return "";
    }
  }
}
