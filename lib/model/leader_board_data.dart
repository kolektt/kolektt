import 'leader_board_user.dart';

class LeaderboardData {
  final List<LeaderboardUser> sellers;
  final List<LeaderboardUser> buyers;
  LeaderboardData({required this.sellers, required this.buyers});

  static LeaderboardData sample = LeaderboardData(
    sellers: [
      LeaderboardUser(id: "1", name: "김판매", amount: 1000000, rank: 1),
      LeaderboardUser(id: "2", name: "이판매", amount: 900000, rank: 2),
      LeaderboardUser(id: "3", name: "박판매", amount: 800000, rank: 3),
      LeaderboardUser(id: "4", name: "최판매", amount: 700000, rank: 4),
      LeaderboardUser(id: "5", name: "정판매", amount: 600000, rank: 5),
    ],
    buyers: [
      LeaderboardUser(id: "1", name: "김구매", amount: 1000000, rank: 1),
      LeaderboardUser(id: "2", name: "이구매", amount: 900000, rank: 2),
      LeaderboardUser(id: "3", name: "박구매", amount: 800000, rank: 3),
      LeaderboardUser(id: "4", name: "최구매", amount: 700000, rank: 4),
      LeaderboardUser(id: "5", name: "정구매", amount: 600000, rank: 5),
    ],
  );
}
