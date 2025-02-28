import 'package:flutter/cupertino.dart';

import '../../components/album_image_view.dart';
import '../../components/metadata_row.dart';
import '../../components/preview_slide_view.dart';
import '../../model/record.dart';

class CollectionRecordDetailView extends StatefulWidget {
  final Record record;

  CollectionRecordDetailView({required this.record});

  @override
  _CollectionRecordDetailViewState createState() =>
      _CollectionRecordDetailViewState();
}

class _CollectionRecordDetailViewState
    extends State<CollectionRecordDetailView> {
  bool showingPreviewSheet = false;
  bool showingAddPreviewSheet = false;
  bool showingEditSheet = false;
  String previewUrl = "";
  late String selectedCondition;
  int currentPage = 0;

  final Map<String, String> conditions = {
    "M": "Mint (완벽한 상태)",
    "NM": "Near Mint (거의 새것)",
    "VG+": "Very Good Plus (매우 좋음)",
    "VG": "Very Good (좋음)",
    "G+": "Good Plus (양호)",
    "G": "Good (보통)",
    "F": "Fair (나쁨)"
  };

  @override
  void initState() {
    super.initState();
    selectedCondition = widget.record.condition ?? "NM";
  }

  List<Widget> get albumImages {
    return [
      Column(
        children: [
          AlbumImageView(url: widget.record.coverImageURL),
          SizedBox(height: 8),
          Text(
            '앞면',
            style: TextStyle(
              color: CupertinoColors.secondaryLabel,
              fontSize: 12,
            ),
          ),
        ],
      ),
      Column(
        children: [
          AlbumImageView(url: widget.record.coverImageURL),
          SizedBox(height: 8),
          Text(
            '뒷면',
            style: TextStyle(
              color: CupertinoColors.secondaryLabel,
              fontSize: 12,
            ),
          ),
        ],
      ),
      Column(
        children: [
          PreviewSlideView(
            url: widget.record.previewUrl,
            onAddPreview: () {
              setState(() {
                showingAddPreviewSheet = true;
              });
            },
          ),
          SizedBox(height: 8),
          Text(
            '미리듣기',
            style: TextStyle(
              color: CupertinoColors.secondaryLabel,
              fontSize: 12,
            ),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.record.title),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.pencil),
          onPressed: () {
            setState(() {
              showingEditSheet = true;
            });
          },
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            Container(
              height: 350,
              child: PageView(
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                children: albumImages,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.record.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.record.artist,
                    style: TextStyle(
                      fontSize: 20,
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    '레코드 정보',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey6,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        MetadataRow(
                          title: '카탈로그 번호',
                          value: widget.record.catalogNumber ?? '미등록',
                        ),
                        MetadataRow(
                          title: '레이블',
                          value: widget.record.label ?? '미등록',
                        ),
                        MetadataRow(
                          title: '포맷',
                          value: widget.record.format ?? '미등록',
                        ),
                        MetadataRow(
                          title: '국가',
                          value: widget.record.country ?? '미등록',
                        ),
                        MetadataRow(
                          title: '발매년도',
                          value: widget.record.releaseYear?.toString() ?? '미등록',
                        ),
                        MetadataRow(
                          title: '장르',
                          value: widget.record.genre ?? '미등록',
                        ),
                        MetadataRow(
                          title: '스타일',
                          value: widget.record.style ?? '미등록',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

