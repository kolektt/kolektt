import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../components/purchase_view.dart';
import '../components/seller_row.dart';
import '../domain/entities/discogs_record.dart';
import '../view_models/record_detail_vm.dart';

class SellersListView extends StatefulWidget {
  final DiscogsRecord record;

  const SellersListView({Key? key, required this.record}) : super(key: key);

  @override
  State<SellersListView> createState() => _SellersListViewState();
}

class _SellersListViewState extends State<SellersListView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RecordDetailViewModel(baseRecord: widget.record),
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
                secondChild: model.salesListingWithProfile!.salesListing.length == 0
                    ? Center(child: Text("판매자가 없어요."))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                  itemCount: model.salesListingWithProfile!.salesListing.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: SellerRow(
                        sellerName: model
                            .salesListingWithProfile!
                            .profiles[index]
                            .display_name
                            .toString(),
                        price: 50000 + (index * 5000),
                        condition: model
                            .salesListingWithProfile!
                            .salesListing[index].condition
                            .toString(),
                        onPurchase: () {
                          _showPurchaseSheet();
                        },
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

  void _showPurchaseSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => PurchaseView(record: widget.record),
    );
  }
}
