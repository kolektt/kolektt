// data/datasources/record_data_source.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class RecordDataSource {
  final SupabaseClient supabase;

  RecordDataSource({required this.supabase});

  Future<dynamic> insertRecord(Map<String, dynamic> recordJson) async {
    try {
      final response = await supabase
          .from('records')
          .insert(recordJson)
          .single(); // 단일 row 반환
      return response;
    } catch (e) {
      throw Exception('Error inserting record: $e');
    }
  }
}
