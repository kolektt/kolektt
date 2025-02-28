import 'package:kolektt/model/supabase/sales_listings.dart';

import '../supabase/profile.dart';

class SalesListingWithProfile {
  List<SalesListing> salesListing = [];
  List<Profiles> profiles = [];

  SalesListingWithProfile({required this.salesListing, required this.profiles});

  factory SalesListingWithProfile.fromJson(Map<String, dynamic> json) {
    return SalesListingWithProfile(
      salesListing: json['sales_listing'].map<SalesListing>((e) => SalesListing.fromJson(e)).toList(),
      profiles: json['profile'].map<Profiles>((e) => Profiles.fromJson(e)).toList(),
    );
  }
}
