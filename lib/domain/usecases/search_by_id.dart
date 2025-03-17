import 'package:kolektt/domain/entities/discogs_record.dart';

import '../repositories/discogs_repository.dart';

class SearchById {
  final DiscogsRepository discogsRepository;

  SearchById(this.discogsRepository);

  Future<DiscogsRecord> call(int id) async {
    return await discogsRepository.getReleaseById(id);
  }
}