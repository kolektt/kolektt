import 'package:flutter/cupertino.dart';

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
            Navigator.of(context).push(
                CupertinoSheetRoute(builder: (context) => SearchView()));
          },
        ),
        CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.bell),
          onPressed: () async {
            Navigator.of(context).push(
                CupertinoSheetRoute(builder: (context) => NotificationsView()));
          },
        ),
      ],
    );
  }
}
