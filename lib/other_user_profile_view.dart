import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'collection_record_detail_view.dart';
import 'home/home_view.dart';
import 'model/record.dart';

class OtherUserProfileView extends StatefulWidget {
  const OtherUserProfileView({super.key});

  @override
  State<OtherUserProfileView> createState() => _OtherUserProfileViewState();
}

class _OtherUserProfileViewState extends State<OtherUserProfileView> {
  bool isFollowing = false;
  int selectedTab = 0;
  final List<String> tabs = ['컬렉션', '활동'];
  // Sample data - you'll need to create a Record class
  final List<Record> sampleRecords = Record.sampleData;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('프로필'),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Profile Header
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Image
                        Container(
                          width: 86,
                          height: 86,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: CupertinoColors.systemGrey6,
                            border: Border.all(
                              color: CupertinoColors.systemGrey5,
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            CupertinoIcons.person_circle_fill,
                            size: 40,
                            color: CupertinoColors.systemGrey,
                          ),
                        ),
                        const SizedBox(width: 20),

                        // Profile Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // User Info
                              const Text(
                                'DJ Name',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Text(
                                'House / Techno',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: CupertinoColors.systemGrey,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Followers/Following
                              Row(
                                children: [
                                  _buildStatColumn('1.2k', '팔로워'),
                                  const SizedBox(width: 24),
                                  _buildStatColumn('824', '팔로잉'),
                                ],
                              ),

                              // Follow Button
                              const SizedBox(height: 8),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  setState(() {
                                    isFollowing = !isFollowing;
                                  });
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: isFollowing
                                        ? CupertinoColors.systemGrey5
                                        : const Color(0xFF0036FF),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    isFollowing ? '팔로잉' : '팔로우',
                                    style: TextStyle(
                                      color: isFollowing
                                          ? CupertinoColors.systemGrey
                                          : CupertinoColors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Stats Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            '총 레코드',
                            '248장',
                            CupertinoIcons.circle_fill,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            '판매 수익',
                            '1,240,000원',
                            CupertinoIcons.money_yen_circle_fill,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Custom Tab Bar
                    Row(
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
                  ],
                ),
              ),
            ),

            // Tab Content
            SliverToBoxAdapter(
              child: selectedTab == 0
                  ? _buildCollectionGrid()
                  : _buildActivityList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: CupertinoColors.systemGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF0036FF)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: CupertinoColors.systemGrey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(1),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
        childAspectRatio: 0.7
      ),
      itemCount: sampleRecords.length,
      itemBuilder: (context, index) {
        final record = sampleRecords[index];
        return GestureDetector(
          onTap: () {
            // Navigate to record detail
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => CollectionRecordDetailView(record: record),
              ),
            );
          },
          child: InstagramStyleRecordCard(record: record),
        );
      },
    );
  }

  Widget _buildActivityList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return ActivityCard(
          type: ActivityType.activity,
          title: '새로운 레코드를 추가했습니다',
          subtitle: 'Bicep - Isles',
          date: '2시간 전',
        );
      },
    );
  }
}
