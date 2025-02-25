import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../model/leader_board_data.dart';
import '../model/leader_board_user.dart';
import 'leader_board_card.dart';

class LeaderboardView extends StatefulWidget {
  final LeaderboardData data;

  const LeaderboardView({Key? key, required this.data}) : super(key: key);

  @override
  _LeaderboardViewState createState() => _LeaderboardViewState();
}

class _LeaderboardViewState extends State<LeaderboardView> {
  int selectedTab = 0;
  final List<String> tabs = ["판매자 순위", "구매자 순위"];

  @override
  Widget build(BuildContext context) {
    // 선택된 탭에 따라 보여줄 유저 리스트 결정
    final List<LeaderboardUser> users =
        selectedTab == 0 ? widget.data.sellers : widget.data.buyers;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 헤더 타이틀
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "리더보드",
            style: CupertinoTheme.of(context)
                .textTheme
                .navTitleTextStyle
                .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        // 탭 선택기
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: List.generate(tabs.length, (index) {
              return Expanded(
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    setState(() {
                      selectedTab = index;
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: selectedTab == index
                          ? primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        tabs[index],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: selectedTab == index
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: selectedTab == index
                              ? CupertinoColors.white
                              : CupertinoColors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 16),
        // 리더보드 리스트 (수평 스크롤)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: users.map((user) => LeaderboardCard(user: user)).toList(),
          ),
        ),
      ],
    );
  }
}
