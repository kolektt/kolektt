class SalesListing {
  /// uuid_generate_v4()
  final String id;

  /// 사용자 식별자 (uuid)
  final String userId;

  /// 판매 가격 (numeric)
  final double price;

  /// 상품(레코드)의 상태 (text)
  final String condition;

  /// 판매 상태 (예: 'For Sale', 'Sold', 등)
  final String status;

  /// 생성 시각 (timestamp), 기본값 CURRENT_TIMESTAMP
  final DateTime createdAt;

  /// 업데이트 시각 (timestamp), 기본값 CURRENT_TIMESTAMP
  final DateTime updatedAt;

  /// 레코드 ID (int8)
  final int recordId;

  SalesListing({
    required this.id,
    required this.userId,
    required this.price,
    required this.condition,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.recordId,
  });

  /// JSON -> SalesListing
  factory SalesListing.fromJson(Map<String, dynamic> json) {
    return SalesListing(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      // numeric -> double 변환
      price: (json['price'] is num)
          ? (json['price'] as num).toDouble()
          : double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      condition: json['condition'] ?? '',
      status: json['status'] ?? '',
      // timestamp -> DateTime 변환
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'].toString())
          : DateTime.now(),
      // int8 -> int 변환
      recordId: json['record_id'] is int
          ? json['record_id'] as int
          : int.tryParse(json['record_id']?.toString() ?? '0') ?? 0,
    );
  }

  /// SalesListing -> JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'price': price,
      'condition': condition,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'record_id': recordId,
    };
  }
}
