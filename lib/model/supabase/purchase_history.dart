class PurchaseHistory {
  final String id;
  final String buyer_id;
  final String seller_id;
  final int record_id;
  final int price;
  final String purchase_date;
  final String created_at;

  PurchaseHistory({
    required this.id,
    required this.buyer_id,
    required this.seller_id,
    required this.record_id,
    required this.price,
    required this.purchase_date,
    required this.created_at,
  });

  factory PurchaseHistory.fromJson(Map<String, dynamic> json) {
    return PurchaseHistory(
      id: json['id'] ?? '',
      buyer_id: json['buyer_id'] ?? '',
      seller_id: json['seller_id'] ?? '',
      record_id: json['record_id'] ?? '',
      price: json['price'] ?? 0,
      purchase_date: json['purchase_date'] ?? '',
      created_at: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyer_id': buyer_id,
      'seller_id': seller_id,
      'record_id': record_id,
      'price': price,
      'purchase_date': purchase_date,
      'created_at': created_at,
    };
  }
}
