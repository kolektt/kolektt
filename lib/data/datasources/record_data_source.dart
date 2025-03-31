import 'package:kolektt/exceptions/data_source_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer';

class RecordDataSource {
  final SupabaseClient supabase;

  RecordDataSource({required this.supabase});

  Future<void> insertRecord(Map<String, dynamic> recordJson) async {
    try {
      // 원본 데이터를 수정하지 않기 위해 복사본 생성
      final Map<String, dynamic> processedRecord = {...recordJson};

      // 배열 형태의 필드를 문자열로 변환 (쉼표로 구분)
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

      // 필수 스키마에 맞춰 artist 필드 추가
      if (!processedRecord.containsKey('artist') || processedRecord['artist'] == null) {
        final title = processedRecord['title'] as String? ?? '';
        if (title.contains('-')) {
          processedRecord['artist'] = title.split('-')[0].trim();
          processedRecord['title'] = title.split('-')[1].trim();
        } else {
          processedRecord['artist'] = 'Unknown Artist';
        }
      }

      // 필수 필드가 없으면 빈 문자열로 채움
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
      // 발생한 예외를 커스텀 예외로 감싸 상위 레이어로 전달
      throw DataSourceException('Error inserting record', e);
    }
  }
}
