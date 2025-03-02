// datasource/collection_remote_data_source.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class CollectionRemoteDataSource {
  final SupabaseClient supabase;

  CollectionRemoteDataSource({required this.supabase});

  Future<List<Map<String, dynamic>>> fetchUserCollection(String userId) async {
    final response = await supabase
        .from('user_collections')
        .select('*, records(*)')
        .eq('user_id', userId.toString());

    // response가 List 타입이라고 가정
    return (response as List).cast<Map<String, dynamic>>();
  }
}
