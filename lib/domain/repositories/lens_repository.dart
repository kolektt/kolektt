abstract class ILensRepository {
  Future<Map<String, dynamic>> fetchLensData(String imageUrl);
}
