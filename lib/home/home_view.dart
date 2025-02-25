import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kolektt/home/home_view.dart' as homeView;

import '../main.dart';
import '../view/collection_record_detail_view.dart';
import '../components/build_status_column.dart';
import '../view/home_view.dart';
import '../model/popular_record.dart';
import '../model/record.dart';
import '../view/other_user_profile_view.dart';


// 데이터 모델 (간략한 예제)

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

// MARK: - Cupertino StatCard & SalesStatCard

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 28, // Equivalent to .title2
            color: color,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: CupertinoColors.systemGrey,
            ),
          ),
        ],
      ),
    );
  }
}

class SalesStatCard extends StatelessWidget {
  final String totalSales;
  final String soldCount;
  final Color color;

  const SalesStatCard({
    Key? key,
    required this.totalSales,
    required this.soldCount,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(CupertinoIcons.money_dollar_circle, size: 28, color: color),
          SizedBox(height: 8),
          Column(
            children: [
              Text(totalSales,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.black)),
              Text(soldCount,
                  style: TextStyle(
                      fontSize: 14, color: CupertinoColors.systemGrey)),
            ],
          ),
          SizedBox(height: 4),
          Text("판매 수익",
              style:
                  TextStyle(fontSize: 12, color: CupertinoColors.systemGrey)),
        ],
      ),
    );
  }
}

// MARK: - ActivityCard

enum ActivityType { sale, purchase, activity }

class ActivityCard extends StatelessWidget {
  final ActivityType type;
  final String title;
  final String subtitle;
  final String date;
  final String? status;
  final Color? statusColor;

  const ActivityCard({
    Key? key,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.date,
    this.status,
    this.statusColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // 앨범 커버 (임시 이미지)
          Container(
            width: 50,
            height: 50,
            color: CupertinoColors.systemGrey.withOpacity(0.2),
            child: Icon(CupertinoIcons.music_note, color: CupertinoColors.systemGrey),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 14, color: CupertinoColors.systemGrey)),
                Text(subtitle,
                    style:
                        TextStyle(fontSize: 16, color: CupertinoColors.black)),
                if (status != null)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: (statusColor ?? primaryColor).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(status!,
                        style: TextStyle(
                            fontSize: 12, color: statusColor ?? primaryColor)),
                  ),
              ],
            ),
          ),
          Text(date,
              style:
                  TextStyle(fontSize: 12, color: CupertinoColors.systemGrey)),
        ],
      ),
    );
  }
}

// MARK: - Followers / Following / OtherUserProfile Views

class FollowersListView extends StatelessWidget {
  const FollowersListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("팔로워")),
      child: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 20,
          itemBuilder: (_, index) {
            return CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) => OtherUserProfileView()),
                );
              },
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor:
                        CupertinoColors.systemGrey.withOpacity(0.2),
                    child: Icon(CupertinoIcons.person,
                        color: CupertinoColors.systemGrey),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("DJ Name", style: TextStyle(fontSize: 16)),
                      Text("House / Techno",
                          style: TextStyle(
                              fontSize: 12, color: CupertinoColors.systemGrey)),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class FollowingListView extends StatelessWidget {
  const FollowingListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("팔로잉")),
      child: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 20,
          itemBuilder: (_, index) {
            return CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) => OtherUserProfileView()),
                );
              },
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor:
                        CupertinoColors.systemGrey.withOpacity(0.2),
                    child: Icon(CupertinoIcons.person,
                        color: CupertinoColors.systemGrey),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("DJ Name", style: TextStyle(fontSize: 16)),
                      Text("House / Techno",
                          style: TextStyle(
                              fontSize: 12, color: CupertinoColors.systemGrey)),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// MARK: - Sale / Purchase / SalesHistory Views

class SaleListView extends StatelessWidget {
  const SaleListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(5, (index) {
            return ActivityCard(
              type: ActivityType.sale,
              title: "판매중인 레코드",
              subtitle: "Bicep - Isles",
              date: "3일 전",
              status: "판매중",
              statusColor: primaryColor,
            );
          }),
        ),
      ),
    );
  }
}

class PurchaseListView extends StatelessWidget {
  const PurchaseListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(5, (index) {
            return ActivityCard(
              type: ActivityType.purchase,
              title: "구매한 레코드",
              subtitle: "Bicep - Isles",
              date: "1주일 전",
              status: "구매완료",
              statusColor: CupertinoColors.systemGrey,
            );
          }),
        ),
      ),
    );
  }
}

class SalesHistoryView extends StatefulWidget {
  const SalesHistoryView({Key? key}) : super(key: key);

  @override
  _SalesHistoryViewState createState() => _SalesHistoryViewState();
}

class _SalesHistoryViewState extends State<SalesHistoryView> {
  SalesHistoryPeriod selectedPeriod = SalesHistoryPeriod.all;
  final List<SaleRecord> salesData = SaleRecord.sampleData;

  List<SaleRecord> get filteredSales {
    final now = DateTime.now();
    return salesData.where((sale) {
      final diff = now.difference(sale.saleDate);
      switch (selectedPeriod) {
        case SalesHistoryPeriod.week:
          return diff.inDays <= 7;
        case SalesHistoryPeriod.month:
          return diff.inDays <= 30;
        case SalesHistoryPeriod.threeMonths:
          return diff.inDays <= 90;
        case SalesHistoryPeriod.sixMonths:
          return diff.inDays <= 180;
        case SalesHistoryPeriod.year:
          return diff.inDays <= 365;
        case SalesHistoryPeriod.all:
          return true;
      }
    }).toList();
  }

  int get totalRevenue =>
      filteredSales.fold(0, (sum, sale) => sum + sale.price);

  int get averagePrice =>
      filteredSales.isEmpty ? 0 : totalRevenue ~/ filteredSales.length;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("판매 내역")),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              // 기간 필터
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: SalesHistoryPeriod.values.length,
                  separatorBuilder: (_, __) => SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final period = SalesHistoryPeriod.values[index];
                    return CupertinoButton(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: selectedPeriod == period
                          ? primaryColor
                          : CupertinoColors.systemGrey4,
                      borderRadius: BorderRadius.circular(20),
                      onPressed: () {
                        setState(() {
                          selectedPeriod = period;
                        });
                      },
                      child: Text(
                        period.rawValue,
                        style: TextStyle(
                            color: selectedPeriod == period
                                ? CupertinoColors.white
                                : CupertinoColors.black),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              // 판매 분석 카드
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: SalesAnalysisCard(
                        title: "총 판매액",
                        value: "$totalRevenue원",
                        icon: CupertinoIcons.money_dollar_circle,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: SalesAnalysisCard(
                        title: "평균 판매가",
                        value: "$averagePrice원",
                        icon: CupertinoIcons.chart_bar,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // 판매 내역 리스트
              Column(
                children: filteredSales
                    .map((sale) => SalesListRow(sale: sale))
                    .toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SalesAnalysisCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const SalesAnalysisCard(
      {Key? key, required this.title, required this.value, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: primaryColor),
          SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.black)),
          SizedBox(height: 4),
          Text(title,
              style:
                  TextStyle(fontSize: 12, color: CupertinoColors.systemGrey)),
        ],
      ),
    );
  }
}

// 임시 SaleRecord 모델 및 SalesListRow 위젯
class SaleRecord {
  final DateTime saleDate;
  final int price;

  SaleRecord({required this.saleDate, required this.price});

  static List<SaleRecord> sampleData = [
    SaleRecord(
        saleDate: DateTime.now().subtract(Duration(days: 3)), price: 30000),
    SaleRecord(
        saleDate: DateTime.now().subtract(Duration(days: 10)), price: 50000),
    // 추가 샘플 데이터...
  ];
}

enum SalesHistoryPeriod { week, month, threeMonths, sixMonths, year, all }

extension SalesHistoryPeriodExtension on SalesHistoryPeriod {
  String get rawValue {
    switch (this) {
      case SalesHistoryPeriod.week:
        return "1주일";
      case SalesHistoryPeriod.month:
        return "1개월";
      case SalesHistoryPeriod.threeMonths:
        return "3개월";
      case SalesHistoryPeriod.sixMonths:
        return "6개월";
      case SalesHistoryPeriod.year:
        return "1년";
      case SalesHistoryPeriod.all:
        return "전체";
    }
  }
}

class SalesListRow extends StatelessWidget {
  final SaleRecord sale;

  const SalesListRow({Key? key, required this.sale}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(CupertinoIcons.doc_text, color: primaryColor),
          SizedBox(width: 8),
          Text("${sale.price}원", style: TextStyle(fontSize: 16)),
          Spacer(),
          Text(
              "${sale.saleDate.month}/${sale.saleDate.day}/${sale.saleDate.year}",
              style:
                  TextStyle(fontSize: 12, color: CupertinoColors.systemGrey)),
        ],
      ),
    );
  }
}

// MARK: - InstagramStyleRecordCard

class InstagramStyleRecordCard extends StatelessWidget {
  final Record record;

  const InstagramStyleRecordCard({Key? key, required this.record})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // 자식 위젯 크기에 맞게 최소한의 공간만 사용
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Image.network(
            record.coverImageURL.toString(),
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min, // 여기서도 최소 크기로 설정
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                record.title,
                style: const TextStyle(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                record.artist,
                style: const TextStyle(
                  fontSize: 10,
                  color: CupertinoColors.systemGrey,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// 임시 상세 페이지들

class DJsPickListView extends StatelessWidget {
  const DJsPickListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("DJ's List")),
      child: Center(child: Text("All DJ Picks")),
    );
  }
}

enum InterviewContentType { text, quote, recordHighlight }

class InterviewContent {
  final String id;
  final InterviewContentType type;
  final String text;
  final List<Record> records;

  InterviewContent({
    required this.id,
    required this.type,
    required this.text,
    required this.records,
  });
}

class DJ {
  final String id;
  final String name;
  final String title;
  final Uri imageURL;
  final int yearsActive;
  final int recordCount;
  final List<InterviewContent> interviewContents;

  DJ({
    required this.id,
    required this.name,
    required this.title,
    required this.imageURL,
    required this.yearsActive,
    required this.recordCount,
    required this.interviewContents,
  });

  static List<DJ> sampleData = [
    DJ(
      id: "1",
      name: "DJ Huey",
      title: "House / Techno",
      imageURL: Uri.parse("https://s.pstatic.net/dthumb.phinf/?src=%22https%3A%2F%2Fs.pstatic.net%2Fshop.phinf%2F20250217_3%2F17397898415832ySrH_PNG%2FED9994EBA9B4%252BECBAA1ECB298%252B2025-02-17%252B195422.png%22&type=ff364_236&service=navermain"),
      yearsActive: 5,
      recordCount: 248,
      interviewContents: [
        InterviewContent(
          id: "1",
          type: InterviewContentType.text,
          text: "DJ Huey is a DJ and producer based in Seoul, South Korea.",
          records: [],
        ),
        InterviewContent(
          id: "2",
          type: InterviewContentType.recordHighlight,
          text: "DJ Huey's Top 3 Records",
          records: Record.sampleData.take(3).toList(),
        ),
      ],
    ),
    DJ(
      id: "2",
      name: "DJ Sarah",
      title: "Techno / Electro",
      imageURL: Uri.parse("https://s.pstatic.net/dthumb.phinf/?src=%22https%3A%2F%2Fs.pstatic.net%2Fshop.phinf%2F20250217_3%2F17397898415832ySrH_PNG%2FED9994EBA9B4%252BECBAA1ECB298%252B2025-02-17%252B195422.png%22&type=ff364_236&service=navermain"),
      yearsActive: 3,
      recordCount: 120,
      interviewContents: [
        InterviewContent(
          id: "1",
          type: InterviewContentType.text,
          text: "DJ Sarah is a DJ and producer based in Berlin, Germany.",
          records: [],
        ),
        InterviewContent(
          id: "2",
          type: InterviewContentType.recordHighlight,
          text: "DJ Sarah's Top 3 Records",
          records: Record.sampleData.take(3).toList(),
        ),
      ],
    ),
  ];
}

class GenreButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onPressed;

  const GenreButton(
      {Key? key,
      required this.title,
      required this.isSelected,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: isSelected ? CupertinoColors.black : CupertinoColors.systemGrey4,
      borderRadius: BorderRadius.circular(20),
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? CupertinoColors.white : CupertinoColors.black,
        ),
      ),
    );
  }
}

class GenreScrollView extends StatelessWidget {
  final List<String> genres;
  final ValueNotifier<String> selectedGenre;

  const GenreScrollView(
      {Key? key, required this.genres, required this.selectedGenre})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ValueListenableBuilder<String>(
        valueListenable: selectedGenre,
        builder: (context, genre, _) => ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: genres.length,
          separatorBuilder: (_, __) => SizedBox(width: 10),
          itemBuilder: (context, index) {
            final title = genres[index];
            return GenreButton(
              title: title,
              isSelected: genre == title,
              onPressed: () {
                selectedGenre.value = title;
              },
            );
          },
        ),
      ),
    );
  }
}

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

class GenreTag extends StatelessWidget {
  final String text;

  const GenreTag({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey4,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}
