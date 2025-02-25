import 'package:flutter/cupertino.dart';
import 'package:kolektt/view/record_detail_view.dart';

import '../components/seller_row.dart';
import '../model/record.dart';

class SellersListView extends StatelessWidget {
  final Record record;

  const SellersListView({Key? key, required this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('판매자 목록'),
        previousPageTitle: '뒤로',
      ),
      child: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 10,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SellerRow(
                sellerName: 'DJ Name ${index + 1}',
                price: 50000 + (index * 5000),
                condition: 'VG+',
                onPurchase: () {},
              ),
            );
          },
        ),
      ),
    );
  }
}
