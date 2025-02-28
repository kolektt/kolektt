import 'package:flutter/cupertino.dart';
import 'package:kolektt/model/supabase/sales_listings.dart';

import '../repository/sale_repository.dart';

class SaleViewModel extends ChangeNotifier {
  final SaleRepository saleRepository;

  SaleViewModel({required this.saleRepository});

  List<SalesListing> _sales = [];

  List<SalesListing> get sales => _sales;

  bool _isSaleLoading = false;
  bool get isSaleLoading => _isSaleLoading;

  Future<void> getSales() async {
    _sales = await saleRepository.getSales();
    notifyListeners();
  }

  Future<void> addSale(SalesListing sale) async {
    setLoading(true);
    await saleRepository.addSale(sale);
    await getSales();
    setLoading(false);
  }

  void setLoading(bool isLoading) {
    _isSaleLoading = isLoading;
    notifyListeners();
  }
}
