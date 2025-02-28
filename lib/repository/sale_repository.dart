import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/supabase/sales_listings.dart';

class SaleRepository {
  static const String tableName = 'sales_listings';
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<SalesListing>> getSales() async {
    final response = await supabase.from(tableName).select();
    return response.map((e) => SalesListing.fromJson(e)).toList();
  }

  Future<void> addSale(SalesListing sale) async {
    await supabase.from(tableName).upsert(sale.toJson());
  }
}
