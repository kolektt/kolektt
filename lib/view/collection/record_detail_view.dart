import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kolektt/figma_colors.dart';
import 'package:provider/provider.dart';

import '../../data/models/discogs_record.dart';
import '../../model/local/collection_record.dart';
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
  late RecordDetailsViewModel model;
  @override
  void initState() {
    super.initState();
    model = context.read<RecordDetailsViewModel>();
    model.collectionRecord = widget.collectionRecord;
    print("model artist: ${model.collectionRecord.record.artist}");
  }

  @override
  Widget build(BuildContext context) {
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
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // 앨범 커버 이미지 및 텍스트 오버레이
          Stack(
            alignment: Alignment.center,
            children: [
              Image.network(
                record.coverImage.isNotEmpty
                    ? record.coverImage
                    : 'https://via.placeholder.com/600x400',
                // 커버 이미지가 없으면 대체 이미지 사용
                height: 400,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ],
          ),

          // 앨범 제목과 아티스트
          Container(
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
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    final List<Artist> artistList = model.entityRecord.artists;

                    if (artistList.length == 1) {
                      // artist 페이지로 이동
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => ArtistDetailView(artist: artistList.first),
                        ),
                      );
                      return;
                    }

                    // 아티스트 이름을 누르면 아티스트 페이지로 이동
                    showCupertinoModalPopup(context: context, builder: (BuildContext context) {
                      return CupertinoActionSheet(
                        title: Text('Artist'),
                        actions: [
                          for (final artist in artistList)
                            CupertinoActionSheetAction(
                              onPressed: () {
                                Navigator.pop(context);
                                // artist 페이지로 이동
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => ArtistDetailView(artist: artist),
                                  ),
                                );
                                debugPrint('artist: ${artist.toJson()}');
                              },
                              child: Text(artist.name),
                            ),

                          // Close 버튼
                          CupertinoActionSheetAction(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('닫기', style: TextStyle(color: CupertinoColors.systemRed)),
                          ),
                        ]
                      );
                    });
                  },
                  child: Text(
                    record.artist,
                    style: FigmaTextStyles()
                        .bodylg
                        .copyWith(color: Color(0xFF2563EB)),
                  ),
                ),
                const SizedBox(height: 4),
                // 포맷, 발매년도, 소장 상태(사용자 지정)를 조합하여 표시
                Text(
                  '${record.format.isNotEmpty ? record.format : 'N/A'} / ${record.releaseYear} / ${userCollection.condition ?? record.condition}',
                  style: FigmaTextStyles()
                      .bodylg
                      .copyWith(color: Color(0xFF4B5563)),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // 레코드 상세 정보 섹션
          Container(
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
                  // 2열이므로 두 칼럼을 Flex 비율로 나눔
                  columnWidths: const {
                    0: FlexColumnWidth(),
                    1: FlexColumnWidth(),
                  },
                  children: [
                    // 첫 번째 행: Catalog Number / Label
                    TableRow(
                      children: [
                        _buildCell('Catalog Number', '88883716861'),
                        _buildCell('Label', 'Columbia'),
                      ],
                    ),
                    // 두 번째 행: Country / Released
                    TableRow(
                      children: [
                        _buildCell('Country', 'USA'),
                        _buildCell('Released', '2025'),
                      ],
                    ),
                    // 세 번째 행: Genre / Speed
                    TableRow(
                      children: [
                        _buildCell('Genre', 'Electronic, Pop'),
                        _buildCell('Speed', '33 RPM'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // 소장 상태 섹션

          Container(
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
                SizedBox(height: 16),
                Table(
                  // 2열이므로 두 칼럼을 Flex 비율로 나눔
                  columnWidths: const {
                    0: FlexColumnWidth(),
                    1: FlexColumnWidth(),
                  },
                  children: [
                    // 첫 번째 행: Sleeve Grade / Media Grade
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
                        _buildConditionValue(
                            userCollection.condition_note ?? "N/A"),
                      ],
                    )
                    // 두 번째 행: Sleeve Condition / Media Condition
                  ],
                ),
                Text(
                  userCollection.condition_note ?? '',
                  style: FigmaTextStyles()
                      .bodysm
                      .copyWith(color: Color(0xFF4B5563)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  TableCell _buildCell(
    String label,
    String value,
  ) {
    return TableCell(
      child: Padding(
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
      ),
    );
  }

  Widget _buildConditionLabel(String label) {
    return TableCell(
      child: Text(
        label,
        style: FigmaTextStyles()
            .headingheading6
            .copyWith(color: CupertinoColors.black),
      ),
    );
  }

  Widget _buildConditionValue(String value) {
    return TableCell(
      child: Text(
        value,
        style: FigmaTextStyles().bodysm.copyWith(color: FigmaColors.primary60),
      ),
    );
  }
}
