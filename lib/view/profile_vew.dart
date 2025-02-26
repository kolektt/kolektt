import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart'; // primaryColor 등
import '../view_models/auth_vm.dart'; // AuthViewModel
import 'login_view.dart'; // 로그인 화면

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  // DB에서 불러온 프로필/통계 정보
  String displayName = '';
  String genre = '';
  int recordCount = 0; // "레코드" 탭 개수
  int followingCount = 0; // 팔로잉 수
  int followerCount = 0; // 팔로워 수
  int totalRecords = 0; // 총 레코드 수
  int totalSales = 0; // 누적 판매액 (원)

  bool isLoadingProfile = false;
  String? errorMessage;

  // 탭 관련
  int selectedTab = 0;
  final List<String> tabs = ["컬렉션", "판매중", "구매", "활동"];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  /// Supabase에서 profiles, user_stats 정보를 불러오는 메서드
  Future<void> _loadProfileData() async {
    setState(() {
      isLoadingProfile = true;
      errorMessage = null;
    });

    try {
      final auth = context.read<AuthViewModel>();
      final user = auth.currentUser;
      debugPrint("현재 사용자: $user");
      if (user == null) {
        // 로그인되지 않았다면 예외
        throw Exception('로그인이 필요합니다.');
      }

      // 1) 프로필 정보
      final profileData = await auth.supabase
          .from('profiles')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      if (profileData == null) {
        throw Exception("해당 사용자 프로필이 존재하지 않습니다.");
      }

      displayName = profileData['nickname'] ?? '익명';
      genre = profileData['genre'] ?? '장르 정보 없음';

      // 2) 통계 정보
      final statsData = await auth.supabase
          .from('user_stats')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      if (statsData != null) {
        recordCount = statsData['record_count'] ?? 0;
        followingCount = statsData['following_count'] ?? 0;
        followerCount = statsData['follower_count'] ?? 0;
        totalRecords = statsData['total_records'] ?? 0;
        totalSales = statsData['total_sales'] ?? 0;
      }
    } catch (e) {
      errorMessage = '프로필 로드 오류: $e';
    } finally {
      setState(() {
        isLoadingProfile = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    final user = auth.currentUser;

    // 1) 로그인되지 않은 경우 → 즉시 LoginView로 이동
    if (user == null) {
      // Build가 끝난 직후에 pushReplacement로 이동
      WidgetsBinding.instance.addPostFrameCallback((_) {
        debugPrint("로그인되지 않았습니다. 로그인 화면으로 이동합니다: $user");
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (_) => LoginView()),
        );
      });
      // 화면에는 아무것도 표시하지 않음
      return const SizedBox();
    }

    // 2) 로딩
    if (isLoadingProfile) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("프로필"),
        ),
        child: const Center(child: CupertinoActivityIndicator()),
      );
    }

    // 3) 에러
    if (errorMessage != null) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("프로필"),
        ),
        child: Center(
          child: Text(
            errorMessage!,
            style: const TextStyle(color: CupertinoColors.systemRed),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // 4) 정상 로그인 + 프로필 로드됨
    return _buildLoggedInUI(context);
  }

  /// 로그인된 상태의 UI (원본 코드)
  Widget _buildLoggedInUI(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("프로필"),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.news),
          onPressed: () {
            // TODO: 판매 히스토리 화면 이동
          },
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              // 프로필 헤더
              _buildProfileHeader(context),

              // 통계 카드
              _buildStatCards(context),

              // 탭 메뉴
              _buildTabMenu(context),

              // 탭 컨텐츠
              _buildTabContent(context),
            ],
          ),
        ),
      ),
    );
  }

  // -----------------------------------------------
  // 이하 부분: 프로필 헤더/UI = 기존과 동일
  // -----------------------------------------------

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        border: Border(
          bottom: BorderSide(
            color: CupertinoColors.systemGrey5,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // 프로필 이미지
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: primaryColor.withOpacity(0.2),
                width: 3,
              ),
            ),
            child: CircleAvatar(
              backgroundColor: CupertinoColors.systemGrey.withOpacity(0.1),
              child: Icon(
                CupertinoIcons.person_alt_circle,
                size: 60,
                color: primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 사용자 닉네임
          Text(
            displayName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            genre,
            style: const TextStyle(
              color: CupertinoColors.systemGrey,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),

          // 통계
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatColumn("$recordCount", "레코드"),
              _buildVerticalDivider(),
              _buildStatColumn("$followingCount", "팔로잉"),
              _buildVerticalDivider(),
              _buildStatColumn("$followerCount", "팔로워"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCards(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // 총 레코드
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, primaryColor.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(CupertinoIcons.music_note,
                      color: CupertinoColors.white, size: 28),
                  const SizedBox(height: 12),
                  Text(
                    "$totalRecords장",
                    style: const TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "총 레코드",
                    style: TextStyle(
                      color: CupertinoColors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          // 총 판매액
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.systemGrey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(CupertinoIcons.cart,
                      color: CupertinoColors.black, size: 28),
                  const SizedBox(height: 12),
                  Text(
                    "${(totalSales / 10000).toStringAsFixed(1)}만원",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "총 판매액",
                    style: TextStyle(
                      color: CupertinoColors.systemGrey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabMenu(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = selectedTab == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedTab = index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color:
                  isSelected ? CupertinoColors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isSelected
                      ? [
                    BoxShadow(
                      color: CupertinoColors.systemGrey.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                      : null,
                ),
                child: Text(
                  tabs[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                    isSelected ? primaryColor : CupertinoColors.systemGrey,
                    fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTabContent(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: Builder(
        key: ValueKey<int>(selectedTab),
        builder: (context) {
          switch (selectedTab) {
            case 0:
              return _buildCollectionGrid(context);
            case 1:
              return Container(/* SaleListView() */);
            case 2:
              return Container(/* PurchaseListView() */);
            case 3:
              return Container(/* ActivityCard(...) */);
            default:
              return Container();
          }
        },
      ),
    );
  }

  Widget _buildCollectionGrid(BuildContext context) {
    // TODO: records 실제 데이터로 그리드 표시
    return Container(
      height: 200,
      color: CupertinoColors.systemGrey5,
      alignment: Alignment.center,
      child: const Text("컬렉션 GridView 예시"),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: CupertinoColors.systemGrey),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 30,
      width: 1,
      color: CupertinoColors.systemGrey4,
    );
  }
}
