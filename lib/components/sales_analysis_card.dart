import 'package:flutter/cupertino.dart';

import '../main.dart';

class SalesAnalysisCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const SalesAnalysisCard(
      {Key? key, required this.title, required this.value, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: primaryColor),
          SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.black)),
          SizedBox(height: 4),
          Text(title,
              style:
              TextStyle(fontSize: 12, color: CupertinoColors.systemGrey)),
        ],
      ),
    );
  }
}
