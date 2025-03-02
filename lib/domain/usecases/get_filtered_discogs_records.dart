import '../entities/discogs_record.dart';
import '../repositories/discogs_repository.dart';
import '../value_objects/criteria.dart';

class GetFilteredDiscogsRecords {
  final DiscogsRepository repository;

  GetFilteredDiscogsRecords({required this.repository});

  Future<List<DiscogsRecord>> call({
    DiscogsFilterCriteria? filter,
    DiscogsSortCriteria? sort,
  }) async {
    // Repository에 조건을 전달하여 데이터를 가져옵니다.
    return await repository.getDiscogsRecords(
      filter: filter,
      sort: sort,
    );
  }
}
