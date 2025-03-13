// data/datasources/record_data_source.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer';

class RecordDataSource {
  final SupabaseClient supabase;

  RecordDataSource({required this.supabase});

  Future<void> insertRecord(Map<String, dynamic> recordJson) async {
    try {
      // Create a copy of the record to avoid modifying the original
      final Map<String, dynamic> processedRecord = {...recordJson};
      
      // Convert array fields to JSON strings if they exist
      if (processedRecord['genre'] is List) {
        processedRecord['genre'] = processedRecord['genre'].join(', ');
      }
      
      if (processedRecord['label'] is List) {
        processedRecord['label'] = processedRecord['label'].join(', ');
      }
      
      if (processedRecord['style'] is List) {
        processedRecord['style'] = processedRecord['style'].join(', ');
      }
      
      if (processedRecord['format'] is List) {
        processedRecord['format'] = processedRecord['format'].join(', ');
      }
      
      // Add artist field if missing (required by schema)
      if (!processedRecord.containsKey('artist') || processedRecord['artist'] == null) {
        // Extract artist from title or set a default
        final title = processedRecord['title'] as String? ?? '';
        if (title.contains('-')) {
          processedRecord['artist'] = title.split('-')[0].trim();
          processedRecord['title'] = title.split('-')[1].trim();
        } else {
          processedRecord['artist'] = 'Unknown Artist';
        }
      }
      
      // Ensure all required fields have at least empty string values
      final requiredFields = ['title', 'artist', 'genre', 'label', 'format', 'style', 'country'];
      for (final field in requiredFields) {
        if (!processedRecord.containsKey(field) || processedRecord[field] == null) {
          processedRecord[field] = '';
        }
      }
      
      log('Processed record for insertion: $processedRecord');
      
      final response = await supabase
          .from('records')
          .upsert(processedRecord, onConflict: 'record_id')
          .select();
          
      log('insertRecord response: $response');
    } catch (e, stackTrace) {
      log('Error inserting record: $e');
      log('Stack trace: $stackTrace');
      throw Exception('Error inserting record: $e');
    }
  }
}
