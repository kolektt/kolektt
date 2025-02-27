import 'package:flutter/cupertino.dart';

import '../model/discogs_record.dart';

class RecordListItemView extends StatelessWidget {
  final DiscogsRecord record;
  RecordListItemView({required this.record});

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Color(0xFF0036FF);
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        // Navigator.push(
        //   context,
        //   CupertinoPageRoute(builder: (context) => RecordDetailView(record: record)),
        // );
      },
      child: Row(
        children: [
          Image.network(
            record.images[0].uri,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(record.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text(record.artists[0].name,
                    style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                // Text("₩${record[0].price}",
                //     style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
          // Icon(
          //   record.trending ? CupertinoIcons.arrow_up : CupertinoIcons.arrow_down,
          //   color: record.trending ? CupertinoColors.activeGreen : CupertinoColors.destructiveRed,
          // ),
        ],
      ),
    );
  }
}
