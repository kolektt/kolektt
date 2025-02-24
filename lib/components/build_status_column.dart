import 'package:flutter/cupertino.dart';

Widget buildStatColumn(String value, String label) {
  return Column(
    children: [
      Text(
        value,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: CupertinoColors.systemGrey,
        ),
      ),
    ],
  );
}
