import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kolektt/figma_colors.dart';
import 'package:kolektt/view_models/collection_vm.dart';
import 'package:provider/provider.dart';

import '../../data/models/discogs_record.dart';
import '../../model/local/collection_record.dart';
import '../../model/supabase/user_collection.dart';
import '../../view_models/record_details_vm.dart';
import '../artist_detail_view.dart';
import 'collection_edit_page.dart';

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
  final FigmaTextStyles _textStyles = FigmaTextStyles();

  @override
  void initState() {
    super.initState();
    final recordDetailsVM = context.read<RecordDetailsViewModel>();
    recordDetailsVM.collectionRecord = widget.collectionRecord;
    debugPrint("Model artist: ${recordDetailsVM.collectionRecord.record.artist}");
  }

  @override
  Widget build(BuildContext context) {
    final recordDetailsVM = context.watch<RecordDetailsViewModel>();
    final collectionVM = context.watch<CollectionViewModel>();
    final record = recordDetailsVM.collectionRecord.record;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        leading: Navigator.canPop(context)
            ? const CupertinoNavigationBarBackButton(previousPageTitle: '')
            : null,
        trailing: IconButton(
          icon: const Icon(CupertinoIcons.pencil),
          onPressed: () => _navigateToEditPage(recordDetailsVM, collectionVM),
        ),
      ),
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildCoverImage(record),
              _buildTitleSection(record, recordDetailsVM),
              const Divider(height: 1),
              _buildRecordDetailsSection(),
              const Divider(height: 1),
              _buildConditionSection(
                recordDetailsVM.collectionRecord.user_collection,
                record,
              ),
              const SizedBox(height: 40),
            ],
          ),
          if (recordDetailsVM.isLoading)
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

  void _navigateToEditPage(
      RecordDetailsViewModel recordDetailsVM,
      CollectionViewModel collectionVM,
      ) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (_) => CollectionEditPage(
          collection: widget.collectionRecord,
          onSave: (userCollection) async {
            await recordDetailsVM.updateRecord(userCollection);
            await recordDetailsVM.getRecordDetails();
            await collectionVM.fetch();
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Widget _buildCoverImage(dynamic record) {
    final imageUrl = record.coverImage.isNotEmpty
        ? record.coverImage
        : 'https://via.placeholder.com/600x400';
    return Image.network(
      imageUrl,
      height: 400,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  Widget _buildTitleSection(dynamic record, RecordDetailsViewModel recordDetailsVM) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            record.title,
            style: _textStyles.headingheading2.copyWith(color: CupertinoColors.black),
          ),
          const SizedBox(height: 4),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => _showArtistActionSheet(recordDetailsVM),
            child: Text(
              record.artist,
              style: _textStyles.bodylg.copyWith(color: const Color(0xFF2563EB)),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${record.format.isNotEmpty ? record.format : 'N/A'} / ${record.releaseYear} / ${widget.collectionRecord.user_collection.condition ?? record.condition}',
            style: _textStyles.bodylg.copyWith(color: const Color(0xFF4B5563)),
          ),
        ],
      ),
    );
  }

  void _showArtistActionSheet(RecordDetailsViewModel recordDetailsVM) {
    final List<Artist> artists = recordDetailsVM.entityRecord!.artists;
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext popupContext) {
        return CupertinoActionSheet(
          title: const Text('Artist'),
          actions: [
            for (final artist in artists)
              CupertinoActionSheetAction(
                onPressed: () {
                  // popupContext를 사용하여 모달 팝업을 닫습니다.
                  Navigator.pop(popupContext);
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => ArtistDetailView(artist: artist),
                    ),
                  );
                  debugPrint('Artist: ${artist.toJson()}');
                },
                child: Text(artist.name),
              ),
            CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(popupContext),
              child: const Text(
                '닫기',
                style: TextStyle(color: CupertinoColors.systemRed),
              ),
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
            style: _textStyles.headingheading4.copyWith(color: FigmaColors.grey100),
          ),
          Table(
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
            style: _textStyles.headingheading6.copyWith(color: FigmaColors.grey90),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: _textStyles.bodysm.copyWith(color: CupertinoColors.black),
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
            style: _textStyles.headingheading4.copyWith(color: FigmaColors.grey100),
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
                  _buildConditionValue(userCollection.condition ?? record.condition),
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
              style: _textStyles.bodysm.copyWith(color: const Color(0xFF4B5563)),
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
        style: _textStyles.headingheading6.copyWith(color: CupertinoColors.black),
      ),
    );
  }

  Widget _buildConditionValue(String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        value,
        style: _textStyles.bodysm.copyWith(color: FigmaColors.primary60),
      ),
    );
  }
}
