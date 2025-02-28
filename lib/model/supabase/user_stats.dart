class UserStats {
  final String user_id;
  final int record_count;
  final int following_count;
  final int follower_count;
  final int total_records;
  final int total_sales;

  UserStats({
    required this.user_id,
    required this.record_count,
    required this.following_count,
    required this.follower_count,
    required this.total_records,
    required this.total_sales,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      user_id: json['user_id'],
      record_count: json['record_count'] is int
          ? json['record_count'] as int
          : int.tryParse(json['record_count']?.toString() ?? '0') ?? 0,
      following_count: json['following_count'] is int
          ? json['following_count'] as int
          : int.tryParse(json['following_count']?.toString() ?? '0') ?? 0,
      follower_count: json['follower_count'] is int
          ? json['follower_count'] as int
          : int.tryParse(json['follower_count']?.toString() ?? '0') ?? 0,
      total_records: json['total_records'] is int
          ? json['total_records'] as int
          : int.tryParse(json['total_records']?.toString() ?? '0') ?? 0,
      total_sales: json['total_sales'] is int
          ? json['total_sales'] as int
          : int.tryParse(json['total_sales']?.toString() ?? '0') ?? 0,
    );
  }
}
