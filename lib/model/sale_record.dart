class SaleRecord {
  final DateTime saleDate;
  final int price;

  SaleRecord({required this.saleDate, required this.price});

  static List<SaleRecord> sampleData = [
    SaleRecord(
        saleDate: DateTime.now().subtract(Duration(days: 3)), price: 30000),
    SaleRecord(
        saleDate: DateTime.now().subtract(Duration(days: 10)), price: 50000),
    // 추가 샘플 데이터...
  ];
}
