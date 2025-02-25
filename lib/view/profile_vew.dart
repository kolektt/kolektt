import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/activity_card.dart';
import '../components/build_status_column.dart';
import '../components/instagram_style_record_card.dart';
import '../components/sales_stat_card.dart';
import '../components/stat_card.dart';
import '../main.dart';
import '../model/activity_type.dart';
import '../model/record.dart';
import 'collection_record_detail_view.dart';
import 'followers_list_view.dart';
import 'following_list_view.dart';
import 'purchase_list_view.dart';
import 'sale_list_view.dart';
import 'sales_history_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  int totalRecords = 248;
  int totalSales = 1240000;
  int selectedTab = 0;
  final List<String> tabs = ["컬렉션", "판매중", "구매", "활동"];
  final List<Record> records = Record.sampleData;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("프로필"),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.news),
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (_) => SalesHistoryView()),
            );
          },
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              // 프로필 헤더
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                color: CupertinoColors.systemBackground,
                child: Row(
                  children: [
                    // 프로필 이미지
                    CircleAvatar(
                      radius: 43,
                      backgroundColor:
                      CupertinoColors.systemGrey.withOpacity(0.2),
                      child: Icon(CupertinoIcons.person_alt_circle,
                          size: 40, color: CupertinoColors.systemGrey),
                    ),
                    SizedBox(width: 20),
                    // 사용자 정보 및 팔로워/팔로잉
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("DJ Huey",
                              style: CupertinoTheme.of(context)
                                  .textTheme
                                  .navTitleTextStyle
                                  .copyWith(fontWeight: FontWeight.w600)),
                          Text("House / Techno",
                              style: CupertinoTheme.of(context)
                                  .textTheme
                                  .textStyle
                                  .copyWith(color: CupertinoColors.systemGrey)),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (_) => FollowersListView()),
                                    );
                                  },
                                  child: buildStatColumn("1.2k", "레코드")),
                              SizedBox(width: 24),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (_) => FollowingListView()),
                                    );
                                  },
                                  child: buildStatColumn('824', '팔로잉')),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 16),
              // 통계 카드
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: "총 레코드",
                        value: "$totalRecords장",
                        icon: CupertinoIcons.music_note,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: SalesStatCard(
                        totalSales: "${totalSales}원",
                        soldCount: "24장",
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              // 탭 메뉴
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
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 300),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: selectedTab == index
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: selectedTab == index
                                    ? CupertinoColors.black
                                    : CupertinoColors.systemGrey,
                              ),
                              child: Text(tabs[index]),
                            ),
                            const SizedBox(height: 4),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: 2,
                              width: double.infinity,
                              color: selectedTab == index ? primaryColor : Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              // 탭 컨텐츠
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: child,
                ),
                child: Builder(
                  // selectedTab에 따라 key를 변경하여 AnimatedSwitcher가 변경을 감지하게 함
                  key: ValueKey<int>(selectedTab),
                  builder: (context) {
                    switch (selectedTab) {
                      case 0:
                        return SafeArea(
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: records.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 1,
                              mainAxisSpacing: 1,
                              childAspectRatio: 0.76, // 이미지 1:1와 텍스트 영역 높이 고려
                            ),
                            itemBuilder: (context, index) {
                              final record = records[index];
                              return CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (_) => CollectionRecordDetailView(record: record),
                                    ),
                                  );
                                },
                                child: InstagramStyleRecordCard(record: record),
                              );
                            },
                          ),
                        );
                      case 1:
                        return SaleListView();
                      case 2:
                        return PurchaseListView();
                      case 3:
                        return SafeArea(
                          child: Column(
                            children: List.generate(3, (index) {
                              return ActivityCard(
                                type: ActivityType.activity,
                                title: "새로운 레코드를 추가했습니다",
                                subtitle: "Bicep - Isles",
                                date: "2시간 전",
                              );
                            }),
                          ),
                        );
                      default:
                        return Container();
                    }
                  },
                ),
              ),
              // 리더보드 섹션
              // LeaderboardView(data: LeaderboardData.sample),
            ],
          ),
        ),
      ),
    );
  }
}