import 'package:flutter/cupertino.dart';
import 'package:kolektt/model/discogs/discogs_record.dart';
import 'package:provider/provider.dart';

import '../components/seller_row.dart';
import '../view_models/record_detail_vm.dart';

class SellersListView extends StatelessWidget {
  final DiscogsRecord record;

  const SellersListView({Key? key, required this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RecordDetailViewModel(baseRecord: record),
      child: Consumer<RecordDetailViewModel>(
        builder: (context, model, Widget? child) {
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: const Text('판매자 목록'),
              previousPageTitle: '뒤로',
            ),
            child: SafeArea(
              child: AnimatedCrossFade(
                firstChild: Center(child: CupertinoActivityIndicator()),
                secondChild: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: model.salesListing?.length ?? 0,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: SellerRow(
                        sellerName: '판매자 $index',
                        price: model.salesListing?[index].price.toInt() ?? 0,
                        condition: model.salesListing![index].condition,
                        onPurchase: () {},
                      ),
                    );
                  },
                ),
                crossFadeState: model.fetchingSellers
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 300),
              ),
            ),
          );
        },
      ),
    );
  }
}
