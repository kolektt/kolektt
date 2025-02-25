class LeaderboardUser {
  final String id;
  final String name;
  final int amount;
  final int rank;

  var profileImageURL;

  LeaderboardUser(
      {required this.id,
        required this.name,
        required this.amount,
        required this.rank});
}
