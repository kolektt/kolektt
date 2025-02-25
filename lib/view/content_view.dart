import 'package:flutter/cupertino.dart';

import '../main.dart';
import 'collection_view.dart' as coll;
import 'home/home_view.dart';
import 'profile_vew.dart';

class ContentView extends StatelessWidget {
  const ContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: CupertinoThemeData(
        primaryColor: primaryColor,
      ),
      home: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          activeColor: primaryColor,
          inactiveColor: CupertinoColors.systemGrey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: "홈",
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.square_grid_2x2_fill),
              label: "컬렉션",
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_fill),
              label: "프로필",
            ),
          ],
        ),
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              return CupertinoTabView(
                builder: (context) => HomeView(),
              );
            case 1:
              return CupertinoTabView(
                builder: (context) => coll.CollectionView(),
              );
            case 2:
              return CupertinoTabView(
                builder: (context) => const ProfileView(),
              );
            default:
              return Container();
          }
        },
      ),
    );
  }
}