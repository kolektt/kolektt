import 'package:flutter/cupertino.dart';

import '../components/activity_card.dart';
import '../model/activity_type.dart';

class PurchaseListView extends StatelessWidget {
  const PurchaseListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(5, (index) {
            return ActivityCard(
              type: ActivityType.purchase,
              title: "구매한 레코드",
              subtitle: "Bicep - Isles",
              date: "1주일 전",
              status: "구매완료",
              statusColor: CupertinoColors.systemGrey,
            );
          }),
        ),
      ),
    );
  }
}
