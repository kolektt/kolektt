import 'package:flutter/cupertino.dart';

import '../main.dart';
import '../model/sale_record.dart';

class SalesListRow extends StatelessWidget {
  final SaleRecord sale;

  const SalesListRow({Key? key, required this.sale}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(CupertinoIcons.doc_text, color: primaryColor),
          SizedBox(width: 8),
          Text("${sale.price}원", style: TextStyle(fontSize: 16)),
          Spacer(),
          Text(
              "${sale.saleDate.month}/${sale.saleDate.day}/${sale.saleDate.year}",
              style:
              TextStyle(fontSize: 12, color: CupertinoColors.systemGrey)),
        ],
      ),
    );
  }
}
