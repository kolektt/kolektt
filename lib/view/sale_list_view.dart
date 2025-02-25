import 'package:flutter/cupertino.dart';

import '../components/activity_card.dart';
import '../main.dart';
import '../model/activity_type.dart';

class SaleListView extends StatelessWidget {
  const SaleListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(5, (index) {
            return ActivityCard(
              type: ActivityType.sale,
              title: "판매중인 레코드",
              subtitle: "Bicep - Isles",
              date: "3일 전",
              status: "판매중",
              statusColor: primaryColor,
            );
          }),
        ),
      ),
    );
  }
}
