import 'package:flutter/cupertino.dart';

import '../model/record.dart';

class PurchaseView extends StatelessWidget {
  final Record record;

  const PurchaseView({Key? key, required this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: const Text('구매하기'),
      message: const Text('구매 진행 중...'),
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('취소'),
      ),
    );
  }
}
