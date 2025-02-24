import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LeaderboardData {
  final List<LeaderboardUser> sellers;
  final List<LeaderboardUser> buyers;
  LeaderboardData({required this.sellers, required this.buyers});

  static LeaderboardData sample = LeaderboardData(
      sellers: [
        LeaderboardUser(id: "1", name: "김판매", amount: 1000000, rank: 1),
        LeaderboardUser(id: "2", name: "이판매", amount: 900000, rank: 2),
        LeaderboardUser(id: "3", name: "박판매", amount: 800000, rank: 3),
        LeaderboardUser(id: "4", name: "최판매", amount: 700000, rank: 4),
        LeaderboardUser(id: "5", name: "정판매", amount: 600000, rank: 5),
      ],
      buyers: [
        LeaderboardUser(id: "1", name: "김구매", amount: 1000000, rank: 1),
        LeaderboardUser(id: "2", name: "이구매", amount: 900000, rank: 2),
        LeaderboardUser(id: "3", name: "박구매", amount: 800000, rank: 3),
        LeaderboardUser(id: "4", name: "최구매", amount: 700000, rank: 4),
        LeaderboardUser(id: "5", name: "정구매", amount: 600000, rank: 5),
      ],
    );
}

class LeaderboardUser {
  final String id;
  final String name;
  final int amount;
  final int rank;

  var profileImageURL;

  LeaderboardUser(
      {required this.id,
      required this.name,
      required this.amount,
      required this.rank});
}

class LeaderboardView extends StatefulWidget {
  final LeaderboardData data;

  const LeaderboardView({Key? key, required this.data}) : super(key: key);

  @override
  _LeaderboardViewState createState() => _LeaderboardViewState();
}

class UserProfileView extends StatelessWidget {
  final LeaderboardUser user;

  const UserProfileView({required this.user});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(user.name)),
      child: Center(child: Text("User Profile View")),
    );
  }
}

class _LeaderboardViewState extends State<LeaderboardView> {
  int selectedTab = 0;
  final List<String> tabs = ["판매자 순위", "구매자 순위"];
  final Color primaryColor = const Color(0xFF0036FF);

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
        const SizedBox(height: 16),
      ],
    );
  }
}

class LeaderboardCard extends StatelessWidget {
  final LeaderboardUser user;

  const LeaderboardCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (_) => UserProfileView(user: user),
          ),
        );
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 순위 뱃지
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.withOpacity(0.1),
              ),
              child: Center(
                child: Text(
                  "${user.rank}",
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // 프로필 이미지
            if (user.profileImageURL != null)
              ClipOval(
                child: Image.network(
                  user.profileImageURL!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.withOpacity(0.2),
                ),
                child: const Icon(
                  CupertinoIcons.person_fill,
                  color: Colors.grey,
                ),
              ),
            const SizedBox(height: 12),
            // 사용자 정보
            Column(
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "${formatAmount(user.amount)}원",
                  style: const TextStyle(
                      fontSize: 12, color: CupertinoColors.systemGrey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String formatAmount(int amount) {
    // 필요 시 intl 패키지의 NumberFormat 사용 고려
    return amount.toString();
  }
}
