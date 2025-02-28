import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../model/supabase/profile.dart';
import '../../model/supabase/user_stats.dart';
import '../../view_models/auth_vm.dart';
import '../login_view.dart';
import 'edit_profile_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with TickerProviderStateMixin {
  // 프로필 데이터
  String displayName = '';
  String genre = '';
  int recordCount = 0;
  int followingCount = 0;
  int followerCount = 0;
  int totalRecords = 0;
  int totalSales = 0;

  // 상태 관리
  bool isLoadingProfile = false;
  bool _isRefreshing = false;
  String? errorMessage;
  int selectedTab = 0;
  final List<String> tabs = ["컬렉션", "판매중", "구매", "활동"];
  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    try {
      await _loadProfileData();
    } catch (e) {
      debugPrint('리프레시 오류: $e');
    } finally {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  Future<void> _loadProfileData() async {
    setState(() {
      isLoadingProfile = true;
      errorMessage = null;
    });

    try {
      final auth = context.read<AuthViewModel>();
      final user = auth.currentUser;
      if (user == null) {
        throw Exception('로그인이 필요합니다.');
      }

      await auth.fetchProfile();
      final Profiles profileData = auth.profiles;

      setState(() {
        displayName = profileData.display_name ?? '익명';
        genre = profileData.genre ?? '장르 정보 없음';
      });

      await auth.fetchUserStats();
      UserStats statsData = auth.userStats;

      setState(() {
        recordCount = statsData.record_count;
        followingCount = statsData.following_count;
        followerCount = statsData.follower_count;
        totalRecords = statsData.total_records;
        totalSales = statsData.total_sales;
      });
    } catch (e) {
      setState(() {
        errorMessage = '프로필 로드 오류: $e';
      });
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

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (_) => LoginView()),
        );
      });
      return const SizedBox();
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("프로필"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.news),
              onPressed: () {
                // TODO: 판매 히스토리
              },
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.pencil),
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => const EditProfileView(),
                  ),
                ).then((value) async {
                  await auth.fetchProfile();
                  _loadProfileData();
                });
              },
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            CupertinoSliverRefreshControl(
              key: _refreshKey,
              onRefresh: _handleRefresh,
              builder: (
                  BuildContext context,
                  RefreshIndicatorMode refreshState,
                  double pulledExtent,
                  double refreshTriggerPullDistance,
                  double refreshIndicatorExtent,
                  ) {
                return Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (refreshState == RefreshIndicatorMode.refresh ||
                          refreshState == RefreshIndicatorMode.armed)
                        const CupertinoActivityIndicator(
                          radius: 14.0,
                          color: CupertinoColors.activeBlue,
                        ),
                      if (refreshState == RefreshIndicatorMode.drag)
                        Transform.rotate(
                          angle: (pulledExtent / refreshTriggerPullDistance) *
                              2 *
                              3.14159,
                          child: Icon(
                            CupertinoIcons.arrow_down,
                            color: CupertinoColors.systemGrey.withOpacity(
                              pulledExtent / refreshTriggerPullDistance,
                            ),
                            size: 24,
                          ),
                        ),
                      if (refreshState == RefreshIndicatorMode.done)
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 1.0, end: 0.0),
                          duration: const Duration(milliseconds: 300),
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: const Icon(
                                CupertinoIcons.check_mark,
                                color: CupertinoColors.activeGreen,
                                size: 24,
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                );
              },
            ),
            SliverToBoxAdapter(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _isRefreshing ? 0.5 : 1.0,
                child: Column(
                  children: [
                    _buildProfileHeader(),
                    _buildStatCards(),
                    _buildTabMenu(),
                    _buildTabContent(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: primaryColor.withOpacity(0.2),
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: CircleAvatar(
              backgroundColor: CupertinoColors.systemGrey.withOpacity(0.1),
              child: Icon(
                CupertinoIcons.person_alt_circle,
                size: 70,
                color: primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            displayName,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            genre,
            style: const TextStyle(
              color: CupertinoColors.systemGrey,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(recordCount.toString(), "레코드"),
              _buildVerticalDivider(),
              _buildStatItem(followingCount.toString(), "팔로잉"),
              _buildVerticalDivider(),
              _buildStatItem(followerCount.toString(), "팔로워"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: CupertinoColors.systemGrey,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          _buildStatCard(
            icon: CupertinoIcons.music_note,
            value: totalRecords.toString(),
            label: "총 레코드",
            isPrimary: true,
          ),
          const SizedBox(width: 16),
          _buildStatCard(
            icon: CupertinoIcons.money_dollar,
            value: "${(totalSales / 10000).toStringAsFixed(1)}만원",
            label: "총 판매액",
            isPrimary: false,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required bool isPrimary,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isPrimary ? primaryColor : CupertinoColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isPrimary
                  ? primaryColor.withOpacity(0.3)
                  : CupertinoColors.systemGrey.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color:
              isPrimary ? CupertinoColors.white : primaryColor,
              size: 30,
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: TextStyle(
                color: isPrimary
                    ? CupertinoColors.white
                    : CupertinoColors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isPrimary
                    ? CupertinoColors.white.withOpacity(0.8)
                    : CupertinoColors.systemGrey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabMenu() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = selectedTab == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedTab = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? CupertinoColors.white
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [
                    BoxShadow(
                      color: CupertinoColors.systemGrey
                          .withOpacity(0.1),
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
                    color: isSelected
                        ? primaryColor
                        : CupertinoColors.systemGrey,
                    fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTabContent() {
    return Container(
      height: 300,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          "${tabs[selectedTab]} 콘텐츠",
          style: const TextStyle(
            fontSize: 18,
            color: CupertinoColors.systemGrey,
          ),
        ),
      ),
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
