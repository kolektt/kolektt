import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/discogs_record.dart';
import '../../domain/repositories/discogs_repository.dart';
import '../../domain/value_objects/criteria.dart';
import '../datasources/discogs_remote_data_source.dart';

class DiscogsRepositoryImpl implements DiscogsRepository {
  final DiscogsRemoteDataSource remoteDataSource;
  final SupabaseClient supabase;

  DiscogsRepositoryImpl({required this.remoteDataSource, required this.supabase});

  @override
  Future<List<DiscogsRecord>> searchDiscogs(String query, {String? type}) async {
    return await remoteDataSource.searchDiscogs(query, type: type);
  }

  @override
  Future<DiscogsRecord> getReleaseById(int releaseId) async {
    return await remoteDataSource.getReleaseById(releaseId);
  }

  @override
  Future<List<DiscogsRecord>> getDiscogsRecords({
    DiscogsFilterCriteria? filter,
    DiscogsSortCriteria? sort,
  }) async {
    // Supabase 쿼리 예시
    var queryBuilder = supabase.from('discogs_records').select();

    // 필터 조건 적용
    if (filter != null) {
      if (filter.artist != null) {
        queryBuilder = queryBuilder.eq('artist', filter.artist.toString());
      }
      if (filter.genre != null) {
        queryBuilder = queryBuilder.eq('genre', filter.genre.toString());
      }
      if (filter.label != null) {
        queryBuilder = queryBuilder.eq('label', filter.label.toString());
      }
      // 추가 조건 처리...
    }

    // 정렬 조건 적용
    // if (sort != null) {
    //   queryBuilder = queryBuilder.order(sort.sortBy, ascending: sort.sortOrder == SortOrder.ascending);
    // }

    final response = await queryBuilder;
    final data = response as List<dynamic>;
    return data.map((e) {
      // JSON을 DiscogsRecord 엔티티로 변환하는 로직
      return DiscogsRecord(
        id: e['id'],
        title: e['title'],
        artist: e['artist'],
        releaseYear: e['release_year'],
        resourceUrl: e['resource_url'],
        artists: e['artists'],
        notes: e['notes'],
        genre: e['genre'],
        coverImage: e['cover_image'],
        catalogNumber: e['catalog_number'],
        label: e['label'],
        format: e['format'],
        country: e['country'],
        style: e['style'],
        condition: e['condition'],
        conditionNotes: e['condition_notes'],
        recordId: e['record_id'],
      );
    }).toList();
  }
}
