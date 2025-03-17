import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kolektt/data/models/discogs_record.dart';
import 'package:kolektt/figma_colors.dart';
import 'package:kolektt/view_models/artist_detail_vm.dart';
import 'package:provider/provider.dart';

import '../data/models/artist_release.dart';

class ArtistDetailView extends StatefulWidget {
  final Artist artist;

  const ArtistDetailView({Key? key, required this.artist}) : super(key: key);

  @override
  State<ArtistDetailView> createState() => _ArtistDetailViewState();
}

class _ArtistDetailViewState extends State<ArtistDetailView> {
  late ArtistDetailViewModel model;

  @override
  void initState() {
    super.initState();
    model = Provider.of<ArtistDetailViewModel>(context, listen: false);
    model.reset().then((_) {
      model.artist = widget.artist;
      model.fetchArtistRelease().then((_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {});
          }
        });
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (model == null) {
      // Provider로부터 모델을 안전하게 가져옴
      model = Provider.of<ArtistDetailViewModel>(context, listen: false);
      model!.artist = widget.artist;
      model!.fetchArtistRelease().then((_) {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Stack(
          children: [
            // 메인 콘텐츠: 스크롤 가능한 전체 페이지 레이아웃
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 382,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.artist.thumbnailUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // 텍스트 가독성을 위한 그라데이션 오버레이
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                CupertinoColors.black.withOpacity(0.0),
                                CupertinoColors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                        // 아티스트 이름 및 태그 표시
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                widget.artist.name,
                                style: const TextStyle(
                                  color: CupertinoColors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 10,
                                children: [
                                  _buildTag('Alternative Rock'),
                                  _buildTag('RnB'),
                                  _buildTag('24 Albums'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // 투명한 뒤로가기 버튼
                        Positioned(
                          top: 16,
                          left: 16,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              CupertinoIcons.back,
                              color: CupertinoColors.white,
                              size: 32,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 연도 선택 영역
                  Consumer<ArtistDetailViewModel>(
                    builder: (BuildContext context, ArtistDetailViewModel model,
                        Widget? child) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: GestureDetector(
                          onTap: () {
                            showCupertinoModalPopup(
                              context: context,
                              builder: (BuildContext context) {
                                return CupertinoActionSheet(
                                  title: model.selectedYear == -1
                                      ? const Text('연도 선택')
                                      : Text('선택된 연도: ${model.selectedYear}'),
                                  actions: [
                                    for (final year in model.artistRelease!.releases
                                            .map((e) => e.year)
                                            .toSet()
                                            .toList()
                                          ..sort((a, b) => b.compareTo(a)))
                                      CupertinoActionSheetAction(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          await model.selectYear(year);
                                        },
                                        child: Text(year.toString()),
                                      ),
                                    CupertinoActionSheetAction(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        await model.clearYear();
                                      },
                                      child: const Text('전체'),
                                    ),
                                    CupertinoActionSheetAction(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('취소',
                                          style: TextStyle(
                                              color:
                                                  CupertinoColors.systemRed)),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: CupertinoColors.systemGrey4),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  model.selectedYear == -1
                                      ? const Text('연도 선택')
                                      : Text('${model.selectedYear}'),
                                  const Icon(CupertinoIcons.chevron_down,
                                      color: CupertinoColors.systemGrey),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // 앨범 그리드
                  Consumer<ArtistDetailViewModel>(
                    builder: (BuildContext context, ArtistDetailViewModel model, Widget? child) {
                      return model.filterRelease == null
                          ? const Center(child: CupertinoActivityIndicator())
                          : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: List.generate(
                            (model.filterRelease!.releases.length / 2).ceil(),
                                (index) {
                              final firstIndex = index * 2;
                              final secondIndex = firstIndex + 1;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: _buildAlbumItem(model
                                          .filterRelease!
                                          .releases[firstIndex]),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: secondIndex <
                                          model.filterRelease!.releases
                                              .length
                                          ? _buildAlbumItem(model
                                          .filterRelease!
                                          .releases[secondIndex])
                                          : Container(),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            // 로딩 오버레이: isLoading이 true일 때 표시
            if (model.isLoading)
              Container(
                color: CupertinoColors.black.withOpacity(0.3),
                child: const Center(
                  child: CupertinoActivityIndicator(radius: 15),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEAEFFF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: FigmaTextStyles()
            .headingheading5
            .copyWith(color: FigmaColors.grey100),
      ),
    );
  }

  Widget _buildAlbumItem(Release release) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              release.thumb,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const SizedBox(width: 4),
            Text(
              release.title,
              style: FigmaTextStyles()
                  .headingheading5
                  .copyWith(color: CupertinoColors.black),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                release.year.toString(),
                style: FigmaTextStyles()
                    .bodysm
                    .copyWith(color: CupertinoColors.black),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                release.format ?? '',
                style: FigmaTextStyles()
                    .headingheading5
                    .copyWith(color: const Color(0xFF2654FF)),
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
