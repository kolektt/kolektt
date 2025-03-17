import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/supabase/purchase_history.dart';

class PurchaseRepository {
  static const String tableName = 'purchase_history';
  final _supabase = Supabase.instance.client;

  Future<List<PurchaseHistory>> getPurchases() async {
    final response = await _supabase.from(tableName).select();
    return response.map((e) => PurchaseHistory.fromJson(e)).toList();
  }

  Future<void> addPurchase(PurchaseHistory purchase) async {
    final response = await _supabase.from(tableName).upsert(purchase.toJson());
    if (response.error != null) {
      throw Exception('Failed to add purchase: ${response.error!.message}');
    }
  }

  Future<void> updatePurchase(PurchaseHistory purchase) async {
    final response = await _supabase.from(tableName).upsert(purchase.toJson());
    if (response.error != null) {
      throw Exception('Failed to update purchase: ${response.error!.message}');
    }
  }

  Future<void> deletePurchase(PurchaseHistory purchase) async {
    final response = await _supabase.from(tableName).delete().eq('id', purchase.id);
    if (response.error != null) {
      throw Exception('Failed to delete purchase: ${response.error!.message}');
    }
  }

  Future<List<PurchaseHistory>> getPurchaseByBuyerId(String buyerId) async {
    final response = await _supabase.from(tableName).select().eq('buyer_id', buyerId);
    return response.map((e) => PurchaseHistory.fromJson(e)).toList();
  }
}
