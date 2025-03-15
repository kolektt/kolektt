// views/analytics_section.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kolektt/figma_colors.dart';
import 'package:kolektt/model/local/collection_record.dart';
import 'package:provider/provider.dart';

import '../components/analytic_card.dart';
import '../components/decade_distribution_view.dart';
import '../components/genre_distribution_view.dart';
import '../view/collectino_summary_view.dart';
import '../view_models/analytics_vm.dart';

class AnalyticsSection extends StatefulWidget {
  // 컬렉션의 DiscogsRecord 리스트를 입력받습니다.
  final List<CollectionRecord> records;

  const AnalyticsSection({Key? key, required this.records}) : super(key: key);

  @override
  _AnalyticsSectionState createState() => _AnalyticsSectionState();
}

class _AnalyticsSectionState extends State<AnalyticsSection> {
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    // 프레임 완료 후 viewmodel에 컬렉션 분석 실행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AnalyticsViewModel>(context, listen: false).analyzeRecords(widget.records);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AnalyticsViewModel>(
      builder: (context, analyticsVM, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: analyticsVM.hasData && analyticsVM.analytics != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Total Records Card
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: FigmaColors.primary60,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total\nRecords",
                                style: FigmaTextStyles()
                                    .headingheading3
                                    .copyWith(color: CupertinoColors.white),
                              ),
                              Text(
                                "Analyzed by Kolektt",
                                style: TextStyle(
                                  color: FigmaColors.primary30,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox.shrink(),
                              Text(
                                "${analyticsVM.analytics!.totalRecords}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Most Genre Section
                    Text(
                      "Most Genre",
                      style: FigmaTextStyles().headingheading2.copyWith(color: FigmaColors.grey100),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: GenreDistributionView(genres: analyticsVM.analytics!.genres),
                    ),

                    const SizedBox(height: 24),

                    // Favorite Artists Section
                    Text(
                      "Favorite Artists",
                      style: FigmaTextStyles().headingheading2.copyWith(color: FigmaColors.grey100),
                    ),
                    const SizedBox(height: 16),
                    // Artist list with rankings
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 3, // Show top 3 artists
                      itemBuilder: (context, index) {
                        // This is a placeholder - you would need to modify your analytics model
                        // to track artist album counts for a more accurate implementation
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    Text(
                                      "${index + 1}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      index == 0
                                          ? CupertinoIcons.arrow_up
                                          : index == 1
                                              ? CupertinoIcons.minus
                                              : CupertinoIcons.arrow_down,
                                      size: 12,
                                      color: index == 0
                                          ? Colors.blue
                                          : index == 1
                                              ? Colors.grey
                                              : Colors.red,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      index == 0
                                          ? "BTS"
                                          : index == 1
                                              ? "BLACKPINK"
                                              : "TWICE",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "${index == 0 ? 52 : index == 1 ? 34 : 28} Albums",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      height: 4,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Collection Period Section
                    Text(
                      "Collection Period",
                      style: FigmaTextStyles().headingheading2.copyWith(color: FigmaColors.grey100),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "My favorite\nera",
                                style: FigmaTextStyles().headingheading3.copyWith(color: FigmaColors.grey100),
                              ),
                              Text(
                                "${analyticsVM.analytics!.oldestRecord}~${analyticsVM.analytics!.newestRecord}",
                                style: FigmaTextStyles().headingheading2.copyWith(color: FigmaColors.grey100),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 150,
                            child: DecadeDistributionView(
                                decades: analyticsVM.analytics!.decades),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        CupertinoIcons.music_note_list,
                        size: 48,
                        color: CupertinoColors.activeBlue,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "컬렉션을 추가하여\n분석을 시작해보세요",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
