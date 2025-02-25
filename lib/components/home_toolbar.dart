import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../view/SearchView.dart';
import '../view/notification.dart';

class HomeToolbar extends StatelessWidget {
  const HomeToolbar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.search),
          onPressed: () async {
            await showCupertinoModalBottomSheet(
              context: context,
              builder: (_) => SearchView(),
              useRootNavigator: true,
            );
          },
        ),
        CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.bell),
          onPressed: () async {
            await showCupertinoModalBottomSheet(
              context: context,
              builder: (_) => NotificationsView(),
              useRootNavigator: true,
            );
          },
        ),
      ],
    );
  }
}
