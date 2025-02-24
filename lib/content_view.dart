import 'package:flutter/cupertino.dart';
import 'home/home_view.dart';
import 'home_view.dart';
import 'package:kolektt/collection_view.dart' as coll;

const Color primaryColor = Color(0xFF0036FF);

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