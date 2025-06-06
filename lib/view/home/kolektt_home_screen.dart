import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kolektt/figma_colors.dart';
import 'package:provider/provider.dart';

import '../../components/collection_grid_item.dart';
import '../../components/filter_cupertino_sheet.dart';
import '../../model/local/collection_record.dart';
import '../../view_models/analytics_vm.dart';
import '../../view_models/collection_vm.dart';
import '../SearchView.dart';
import '../auto_album_detection_view.dart';
import '../collection/collection_view.dart';

class KolekttHomeScreen extends StatefulWidget {
  const KolekttHomeScreen({super.key});

  @override
  State<KolekttHomeScreen> createState() => _KolekttHomeScreenState();
}

class _KolekttHomeScreenState extends State<KolekttHomeScreen> {
  late AnalyticsViewModel analytics_model;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCollectionData();
    });
    _loadCollectionData();
  }

  Future<void> _loadCollectionData() async {
    final collection_model = context.read<CollectionViewModel>();
    analytics_model = context.read<AnalyticsViewModel>();
    await collection_model.fetch();

    analytics_model.analyzeRecords(collection_model.collectionRecords);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomePageTitle(),
                Row(
                  children: [
                    Expanded(
                      child: Consumer<AnalyticsViewModel>(
                        builder: (context, analyticsModel, child) {
                          return _buildStatCard(
                            title: 'Total\nRecords',
                            value: analyticsModel.analytics != null
                                ? analyticsModel.analytics!.totalRecords.toString()
                                : '0',
                            color: FigmaColors.primary60,
                            strokeColor: FigmaColors.primary70,
                            textColor: CupertinoColors.white,
                            context: context,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Consumer<AnalyticsViewModel>(
                        builder: (BuildContext context, AnalyticsViewModel analyticsModel, Widget? child) {
                          return _buildStatCard(
                            title: 'Most\nGenre',
                            value: analyticsModel.analytics != null
                                ? analyticsModel.analytics!.mostCollectedGenre.toString()
                                : '0',
                            color: CupertinoColors.white,
                            strokeColor: Color(0xffB2C2FF),
                            textColor: FigmaColors.grey100,
                            valueSize: 24,
                            context: context,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildFavoriteArtistCard(context),
                const SizedBox(height: 20),
                Container(
                  height: 56,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'My Collection',
                    style: FigmaTextStyles()
                        .headingheading2
                        .copyWith(color: FigmaColors.grey100),
                  ),
                ),
                const SizedBox(height: 12),
                // _buildAlbumGrid(),
                Consumer<CollectionViewModel>(
                  // key 값은 상태 변화에 따른 전환을 위해 그대로 유지합니다.
                  key: ValueKey<int>(context
                      .read<CollectionViewModel>()
                      .collectionRecords
                      .length +
                      (context.read<CollectionViewModel>().isLoading ? 1 : 0)),
                  builder: (context, model, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // search bar는 항상 상단에 표시됩니다.
                        _buildSearchBar(
                          context,
                          FilterLineButton(
                            classification: model.userCollectionClassification,
                            onFilterResult: (result) async {
                              debugPrint("UserCollectionClassification: ${result.genres}");
                              model.userCollectionClassification = result;
                              await model.filterCollection();
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        // 로딩 중이면 로딩 인디케이터를, 아니면 컬렉션 상태에 따라 메시지 또는 Grid를 보여줍니다.
                        if (model.isLoading)
                          const Center(child: CupertinoActivityIndicator())
                        else if (model.collectionRecords.isEmpty)
                          const Center(child: Text("컬렉션이 없습니다."))
                        else
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: model.collectionRecords.length,
                            itemBuilder: (context, index) {
                              CollectionRecord record = model.collectionRecords[index];
                              record.record.resourceUrl = "https://api.discogs.com/releases/${record.record.id}";
                              // 각 그리드 아이템에 애니메이션 적용
                              return AnimatedGridItem(
                                index: index,
                                child: buildGridItem(context, record, model),
                              );
                            },
                          ),
                        const SizedBox(height: 32),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    required Color strokeColor,
    required Color textColor,
    required BuildContext context,
    double valueSize = 40,
  }) {
    return Container(
      height: 171,
      width: MediaQuery.of(context).size.width,
      decoration: ShapeDecoration(
        color: color,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: strokeColor),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: FigmaTextStyles()
                    .headingheading3
                    .copyWith(color: textColor),
              ),
              Icon(
                CupertinoIcons.right_chevron,
                color: textColor,
                size: 16,
              ),
            ],
          ),
          const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              value,
              style:
                  FigmaTextStyles().headingheading1.copyWith(color: textColor),
              textDirection: TextDirection.rtl,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteArtistCard(context) {
    return Consumer<AnalyticsViewModel>(
      builder: (BuildContext context, AnalyticsViewModel analyticsModel, Widget? child) {
        return Container(
          height: 171,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: CupertinoColors.black,
            border: Border.all(color: FigmaColors.grey90),
            borderRadius: BorderRadius.circular(16),
            image: const DecorationImage(
              image: NetworkImage(
                  'https://www.shutterstock.com/image-vector/no-image-available-icon-template-260nw-1036735678.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Color.fromRGBO(0, 0, 0, 0.5),
                BlendMode.darken,
              ),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Favorite\nArtist',
                style: FigmaTextStyles()
                    .headingheading3
                    .copyWith(color: CupertinoColors.white),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  analyticsModel.analytics != null
                      ? analyticsModel.analytics!.mostCollectedArtist.replaceFirst(" ", "\n")
                      : '0',
                  style: TextStyle(
                    color: CupertinoColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar(BuildContext context, Widget filterButton) {
    return GestureDetector(
      onTap: () async {
        Navigator.of(context).push(
            CupertinoSheetRoute(builder: (context) => SearchView()));
      },
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: FigmaColors.grey10,
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(color: FigmaColors.grey20),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            const Icon(
              CupertinoIcons.search,
              color: CupertinoColors.systemGrey,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Search',
                style: FigmaTextStyles()
                    .bodymd
                    .copyWith(color: FigmaColors.grey50),
              ),
            ),
            filterButton
          ],
        ),
      ),
    );
  }

  Widget _buildAlbumGrid() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 171,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: CupertinoColors.black,
                image: const DecorationImage(
                  image: NetworkImage('https://via.placeholder.com/400x400'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Discovery',
              style: FigmaTextStyles()
                  .headingheading3
                  .copyWith(color: FigmaColors.grey100),
            ),
            const SizedBox(height: 2),
            Text(
              'Daft Punk',
              style: FigmaTextStyles().bodyxs,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '1998 • House',
                  style: FigmaTextStyles().bodyxs,
                ),
                Text(
                  'VG+',
                  style: FigmaTextStyles()
                      .labelxsbold
                      .copyWith(color: FigmaColors.primary70),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget HomePageTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            Text(
              'Kolektt',
              style: FigmaTextStyles()
                  .displaydisplay2
                  .copyWith(color: CupertinoColors.black),
            ),
            Text(
              'All about your records',
              style: FigmaTextStyles().labelxsregular,
            ),
            SizedBox(height: 16)
          ],
        ),
        IconButton(
            iconSize: 48,
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => AutoAlbumDetectionScreen(),
                ),
              );
            },
            icon: Icon(CupertinoIcons.add_circled_solid, color: FigmaColors.primary70))
      ],
    );
  }
}
