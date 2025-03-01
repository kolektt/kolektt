import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/supabase/sales_listings.dart';

class SaleRepository {
  static const String tableName = 'sales_listings';
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<SalesListing>> getSales() async {
    final response = await supabase.from(tableName).select();
    return response.map((e) => SalesListing.fromJson(e)).toList();
  }

  Future<SalesListing?> getSaleById(int id) async {
    final response = await supabase.from(tableName).select().eq('id', id).single();
    return SalesListing.fromJson(response);
  }

  Future<List<SalesListing>> getSaleByRecordId(int recordId) async {
    final response = await supabase.from(tableName).select().eq('record_id', recordId);
    debugPrint('getSaleByRecordId: $response');
    return response.map((e) => SalesListing.fromJson(e)).toList();
  }

  Future<List<SalesListing>> getSaleBySellerId(String sellerId) async {
    final response = await supabase.from(tableName).select().eq('user_id', sellerId);
    debugPrint('getSaleBySellerId: $response');
    return response.map((e) => SalesListing.fromJson(e)).toList();
  }

  Future<void> addSale(SalesListing sale) async {
    await supabase.from(tableName).upsert(sale.toJson());
  }

  Future<void> deleteSale(String id) async {
    await supabase.from(tableName).delete().eq('id', id);
  }
}
