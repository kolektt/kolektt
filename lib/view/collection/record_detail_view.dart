import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kolektt/figma_colors.dart';
import 'package:provider/provider.dart';

import '../../data/models/discogs_record.dart';
import '../../model/local/collection_record.dart';
import '../../model/supabase/user_collection.dart';
import '../../view_models/record_details_vm.dart';
import '../artist_detail_view.dart';

class RecordDetailsView extends StatefulWidget {
  final CollectionRecord collectionRecord;

  const RecordDetailsView({
    Key? key,
    required this.collectionRecord,
  }) : super(key: key);

  @override
  State<RecordDetailsView> createState() => _RecordDetailsViewState();
}

class _RecordDetailsViewState extends State<RecordDetailsView> {
  @override
  void initState() {
    super.initState();
    // 모델에 초기 소장 레코드를 설정
    final model = context.read<RecordDetailsViewModel>();
    model.collectionRecord = widget.collectionRecord;
    debugPrint("Model artist: ${model.collectionRecord.record.artist}");
  }

  @override
  Widget build(BuildContext context) {
    // 모델 업데이트를 실시간 반영
    final model = context.watch<RecordDetailsViewModel>();
    final record = widget.collectionRecord.record;
    final userCollection = widget.collectionRecord.user_collection;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        leading: Navigator.canPop(context)
            ? const CupertinoNavigationBarBackButton(previousPageTitle: '')
            : null,
        trailing: const Icon(CupertinoIcons.pencil),
      ),
      child: Stack(
        children: [
          // 메인 콘텐츠 영역
          ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildCoverImage(record),
              _buildTitleSection(record, model),
              const Divider(height: 1),
              _buildRecordDetailsSection(),
              const Divider(height: 1),
              _buildConditionSection(userCollection, record),
              const SizedBox(height: 40),
            ],
          ),
          // 로딩 상태 오버레이 (데이터 로딩 중일 때)
          if (model.isLoading)
            Container(
              color: CupertinoColors.systemGrey.withOpacity(0.3),
              child: const Center(
                child: CupertinoActivityIndicator(radius: 15),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCoverImage(dynamic record) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.network(
          record.coverImage.isNotEmpty
              ? record.coverImage
              : 'https://via.placeholder.com/600x400',
          height: 400,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ],
    );
  }

  Widget _buildTitleSection(dynamic record, RecordDetailsViewModel model) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            record.title,
            style: FigmaTextStyles()
                .headingheading2
                .copyWith(color: CupertinoColors.black),
          ),
          const SizedBox(height: 4),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => _onArtistPressed(model),
            child: Text(
              record.artist,
              style: FigmaTextStyles()
                  .bodylg
                  .copyWith(color: const Color(0xFF2563EB)),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${record.format.isNotEmpty ? record.format : 'N/A'} / ${record.releaseYear} / ${widget.collectionRecord.user_collection.condition ?? record.condition}',
            style: FigmaTextStyles()
                .bodylg
                .copyWith(color: const Color(0xFF4B5563)),
          ),
        ],
      ),
    );
  }

  void _onArtistPressed(RecordDetailsViewModel model) {
    final List<Artist> artistList = model.entityRecord.artists;
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text('Artist'),
          actions: [
            for (final artist in artistList)
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => ArtistDetailView(artist: artist),
                    ),
                  );
                  debugPrint('Artist: ${artist.toJson()}');
                },
                child: Text(artist.name),
              ),
            CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(context),
              child: const Text('닫기',
                  style: TextStyle(color: CupertinoColors.systemRed)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRecordDetailsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Record\nDetails',
            style: FigmaTextStyles()
                .headingheading4
                .copyWith(color: FigmaColors.grey100),
          ),
          Table(
            // 두 칼럼의 Flex 비율로 나눔
            columnWidths: const {
              0: FlexColumnWidth(),
              1: FlexColumnWidth(),
            },
            children: [
              TableRow(
                children: [
                  _buildTableCell('Catalog Number', '88883716861'),
                  _buildTableCell('Label', 'Columbia'),
                ],
              ),
              TableRow(
                children: [
                  _buildTableCell('Country', 'USA'),
                  _buildTableCell('Released', '2025'),
                ],
              ),
              TableRow(
                children: [
                  _buildTableCell('Genre', 'Electronic, Pop'),
                  _buildTableCell('Speed', '33 RPM'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableCell(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, right: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: FigmaTextStyles()
                .headingheading6
                .copyWith(color: FigmaColors.grey90),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: FigmaTextStyles()
                .bodysm
                .copyWith(color: CupertinoColors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildConditionSection(UserCollection userCollection, dynamic record) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Condition',
            style: FigmaTextStyles()
                .headingheading4
                .copyWith(color: FigmaColors.grey100),
          ),
          const SizedBox(height: 16),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(),
              1: FlexColumnWidth(),
            },
            children: [
              TableRow(
                children: [
                  _buildConditionLabel('Media Grade'),
                  _buildConditionValue(
                      userCollection.condition ?? record.condition),
                ],
              ),
              TableRow(
                children: [
                  _buildConditionLabel('Sleeve Grade'),
                  _buildConditionValue(userCollection.condition_note ?? "N/A"),
                ],
              ),
            ],
          ),
          if ((userCollection.condition_note ?? '').isNotEmpty)
            Text(
              userCollection.condition_note ?? '',
              style: FigmaTextStyles()
                  .bodysm
                  .copyWith(color: const Color(0xFF4B5563)),
            ),
        ],
      ),
    );
  }

  Widget _buildConditionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: FigmaTextStyles()
            .headingheading6
            .copyWith(color: CupertinoColors.black),
      ),
    );
  }

  Widget _buildConditionValue(String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        value,
        style:
        FigmaTextStyles().bodysm.copyWith(color: FigmaColors.primary60),
      ),
    );
  }
}
