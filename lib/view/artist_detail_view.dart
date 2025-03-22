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
  final FigmaTextStyles _textStyles = FigmaTextStyles();

  @override
  void initState() {
    super.initState();
    // 빌드 후 상태 초기화 및 데이터 패치
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final model = context.read<ArtistDetailViewModel>();
      model.reset().then((_) async {
        model.artist = widget.artist;
        await model.fetchArtistRelease();
        if (mounted) setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildYearSelection(),
                _buildAlbumGrid(),
              ],
            ),
          ),
          _buildLoadingOverlay(),
        ],
      ),
    );
  }

  /// 상단 헤더: 배경 이미지, 그라데이션, 아티스트 정보, 뒤로가기 버튼
  Widget _buildHeader() {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 382,
      width: screenWidth,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(widget.artist.thumbnailUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          _buildGradientOverlay(),
          _buildHeaderText(),
          _buildBackButton(),
        ],
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
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
    );
  }

  Widget _buildHeaderText() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
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
    );
  }

  Widget _buildBackButton() {
    return SafeArea(
      child: Positioned(
        top: 16,
        left: 16,
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(
            CupertinoIcons.back,
            color: CupertinoColors.white,
            size: 32,
          ),
          onPressed: () => Navigator.of(context).pop(),
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
        style: _textStyles.headingheading5.copyWith(color: FigmaColors.grey100),
      ),
    );
  }

  /// 연도 선택 영역: 터치 시 연도 선택 액션시트 표시
  Widget _buildYearSelection() {
    return Consumer<ArtistDetailViewModel>(
      builder: (context, model, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: GestureDetector(
            onTap: () => _showYearSelectionActionSheet(model),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: CupertinoColors.systemGrey4),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  model.selectedYear == -1
                      ? Text(
                    '연도 선택',
                    style: FigmaTextStyles().bodymd.copyWith(color: FigmaColors.grey100),
                  )
                      : Text(model.selectedYear.toString()),
                  const Icon(CupertinoIcons.chevron_down, color: CupertinoColors.systemGrey),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showYearSelectionActionSheet(ArtistDetailViewModel model) {
    showCupertinoModalPopup(
      context: context,
      builder: (popupContext) {
        final sortedYears = model.allReleases!.releases
            .map((e) => e.year)
            .toSet()
            .toList()
          ..sort((a, b) => b.compareTo(a));
        return CupertinoActionSheet(
          title: model.selectedYear == -1
              ? const Text('연도 선택')
              : Text('선택된 연도: ${model.selectedYear}'),
          actions: [
            for (final year in sortedYears)
              CupertinoActionSheetAction(
                onPressed: () async {
                  Navigator.pop(popupContext);
                  await model.selectYear(year);
                },
                child: Text(year.toString()),
              ),
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(popupContext);
                await model.clearYear();
              },
              child: const Text('전체'),
            ),
            CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(popupContext),
              child: const Text('취소', style: TextStyle(color: CupertinoColors.systemRed)),
            ),
          ],
        );
      },
    );
  }

  /// 앨범 그리드 영역: 2열 그리드 형태로 앨범 아이템 표시
  Widget _buildAlbumGrid() {
    return Consumer<ArtistDetailViewModel>(
      builder: (context, model, _) {
        if (model.filteredReleases == null) {
          return const Center(child: CupertinoActivityIndicator());
        }
        final releases = model.filteredReleases!.releases;
        final List<Widget> rows = [];
        for (var i = 0; i < (releases.length / 2).ceil(); i++) {
          final firstIndex = i * 2;
          final secondIndex = firstIndex + 1;
          rows.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                children: [
                  Expanded(child: _buildAlbumItem(releases[firstIndex])),
                  const SizedBox(width: 16),
                  Expanded(
                    child: secondIndex < releases.length
                        ? _buildAlbumItem(releases[secondIndex])
                        : Container(),
                  ),
                ],
              ),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(children: rows),
        );
      },
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
            Expanded(
              child: Text(
                release.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: _textStyles.headingheading5.copyWith(color: CupertinoColors.black),
              ),
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
                style: _textStyles.bodysm.copyWith(color: CupertinoColors.black),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                release.format ?? '',
                style: _textStyles.headingheading5.copyWith(color: const Color(0xFF2654FF)),
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 로딩 오버레이: 모델의 isLoading 상태에 따라 표시
  Widget _buildLoadingOverlay() {
    return Consumer<ArtistDetailViewModel>(
      builder: (context, model, _) {
        return model.isLoading
            ? Container(
          color: CupertinoColors.black.withOpacity(0.3),
          child: const Center(
            child: CupertinoActivityIndicator(radius: 15),
          ),
        )
            : const SizedBox.shrink();
      },
    );
  }
}
