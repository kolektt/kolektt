import 'package:kolektt/model/supabase/profile.dart';
import 'package:kolektt/model/supabase/purchase_history.dart';

class PurchaseWithProfile {
  final PurchaseHistory purchase;
  final Profiles seller_profile;
  final Profiles buyer_profile;

  PurchaseWithProfile(this.purchase, this.seller_profile, this.buyer_profile);
}
