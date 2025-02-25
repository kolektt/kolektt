import 'package:flutter/cupertino.dart';

class MetadataRow extends StatelessWidget {
  final String title;
  final String value;

  MetadataRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: CupertinoColors.secondaryLabel,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: CupertinoColors.label,
            ),
          ),
        ],
      ),
    );
  }
}
