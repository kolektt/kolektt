import 'package:flutter/cupertino.dart';

import '../model/record.dart';

class RecordCardView extends StatelessWidget {
  final Record record;
  RecordCardView({required this.record});
  @override
  Widget build(BuildContext context) {
    double cardWidth = (MediaQuery.of(context).size.width - 48) / 2;
    double imageHeight = 160;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: CupertinoColors.systemBackground,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            child: Image.network(
              record.coverImageURL ?? "https://s.pstatic.net/dthumb.phinf/?src=%22https%3A%2F%2Fs.pstatic.net%2Fshop.phinf%2F20250217_3%2F17397898415832ySrH_PNG%2FED9994EBA9B4%252BECBAA1ECB298%252B2025-02-17%252B195422.png%22&type=ff364_236&service=navermain",
              width: cardWidth,
              height: imageHeight,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(record.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text(record.artist,
                    style: TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Row(
                  children: [
                    if (record.releaseYear != null)
                      Text("${record.releaseYear}",
                          style: TextStyle(fontSize: 11, color: CupertinoColors.systemGrey)),
                    if (record.releaseYear != null && record.genre != null)
                      Text(" • ", style: TextStyle(fontSize: 11, color: CupertinoColors.systemGrey)),
                    if (record.genre != null)
                      Text(record.genre!,
                          style: TextStyle(fontSize: 11, color: CupertinoColors.systemGrey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
