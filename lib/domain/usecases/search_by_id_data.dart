import 'package:kolektt/data/models/discogs_record.dart';

import '../repositories/discogs_repository.dart';

class SearchByIdData {
  final DiscogsRepository discogsRepository;

  SearchByIdData(this.discogsRepository);

  Future<DiscogsRecord> call(int releaseId) async {
    return await discogsRepository.getDomainReleaseById(releaseId);
  }
}