import 'package:flutter/cupertino.dart';

import '../components/popular_record_row.dart';
import '../model/popular_record.dart';

class RecordsList extends StatelessWidget {
  final List<PopularRecord> records;

  const RecordsList({Key? key, required this.records}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayed = records.take(5).toList();
    return Column(
      children: List.generate(displayed.length, (index) {
        final record = displayed[index];
        return PopularRecordRow(record: record, rank: index + 1);
      }),
    );
  }
}
