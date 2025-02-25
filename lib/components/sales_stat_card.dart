import 'package:flutter/cupertino.dart';

class SalesStatCard extends StatelessWidget {
  final String totalSales;
  final String soldCount;
  final Color color;

  const SalesStatCard({
    Key? key,
    required this.totalSales,
    required this.soldCount,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(CupertinoIcons.money_dollar_circle, size: 28, color: color),
          SizedBox(height: 8),
          Column(
            children: [
              Text(totalSales,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.black)),
              Text(soldCount,
                  style: TextStyle(
                      fontSize: 14, color: CupertinoColors.systemGrey)),
            ],
          ),
          SizedBox(height: 4),
          Text("판매 수익",
              style:
                  TextStyle(fontSize: 12, color: CupertinoColors.systemGrey)),
        ],
      ),
    );
  }
}
