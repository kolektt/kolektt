import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/analytics_section.dart';
import '../../components/collection_grid_item.dart';
import '../../components/filter_cupertino_sheet.dart';
import '../../model/local/collection_record.dart';
import '../../view_models/collection_vm.dart';
import '../auto_album_detection_view.dart';

class CollectionView extends StatefulWidget {
  const CollectionView({Key? key}) : super(key: key);

  @override
  _CollectionViewState createState() => _CollectionViewState();
}

class _CollectionViewState extends State<CollectionView> {
  // State variables for refresh control
  bool _isRefreshing = false;
  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    // Fetch collection records on initialization
    _loadCollectionData();
  }

  Future<void> _loadCollectionData() async {
    final model = context.read<CollectionViewModel>();
    await model.fetchUserCollectionsWithRecords();
    await model.fetchUserCollectionsUniqueProperties();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    try {
      await _loadCollectionData();
    } catch (e) {
      debugPrint('컬렉션 새로고침 오류: $e');
    } finally {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("컬렉션"),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (_) => AutoAlbumDetectionScreen(),
              ),
            );
          },
          child: const Icon(
            CupertinoIcons.add_circled_solid,
            size: 32,
            color: CupertinoColors.black,
          ),
        ),
      ),
      child: SafeArea(
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Pull-to-refresh control
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

            // Main content
            SliverToBoxAdapter(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _isRefreshing ? 0.5 : 1.0,
                child: Consumer<CollectionViewModel>(
                  builder: (context, model, child) {
                    if (model.isLoading) {
                      if (_isRefreshing) return SizedBox.shrink();
                      return const Center(child: CupertinoActivityIndicator());
                    }
                    if (model.collectionRecords.isEmpty) {
                      return const Center(child: Text("컬렉션이 없습니다."));
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnalyticsSection(records: model.collectionRecords),
                        const SizedBox(height: 16),
                        FilterButton(
                            classification: model.userCollectionClassification,
                            onFilterResult: (result) async {
                              debugPrint(
                                  "UserCollectionClassification: ${result.artists}, ${result.genres}, ${result.labels}");
                              await model.filterCollection(result);
                            }),
                        const SizedBox(height: 16),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: model.collectionRecords.length,
                          itemBuilder: (context, index) {
                            CollectionRecord record =
                                model.collectionRecords[index];
                            record.record.resourceUrl =
                                "https://api.discogs.com/releases/${record.record.id}";
                            return buildGridItem(context, record, model);
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
