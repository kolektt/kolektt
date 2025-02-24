import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'model/record.dart';

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

class MetadataRow extends StatelessWidget {
  final String title;
  final String value;

  MetadataRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: CupertinoColors.secondaryLabel,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: CupertinoColors.label,
            ),
          ),
        ],
      ),
    );
  }
}

class AlbumImageView extends StatelessWidget {
  final String? url;

  AlbumImageView({this.url});

  @override
  Widget build(BuildContext context) {
    if (url != null) {
      return Image.network(
        width: MediaQuery.of(context).size.width,
        url!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildPlaceholder();
        },
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: CupertinoColors.systemGrey6.withOpacity(0.2),
      child: Icon(
        CupertinoIcons.music_note,
        size: 40,
        color: CupertinoColors.systemGrey,
      ),
    );
  }
}

class PreviewSlideView extends StatelessWidget {
  final String? url;
  final VoidCallback onAddPreview;

  PreviewSlideView({this.url, required this.onAddPreview});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: url != null
          ? CupertinoButton(
              onPressed: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) => PreviewPlayerView(url: url!),
                );
              },
              color: CupertinoColors.systemBlue.withOpacity(0.1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    CupertinoIcons.play_circle_fill,
                    size: 60,
                    color: CupertinoColors.systemBlue,
                  ),
                  SizedBox(height: 16),
                  Text(
                    '미리듣기 재생',
                    style: TextStyle(
                      color: CupertinoColors.systemBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          : CupertinoButton(
            onPressed: onAddPreview,
            color: CupertinoColors.systemGrey6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.plus_circle,
                  size: 60,
                  color: CupertinoColors.systemGrey,
                ),
                SizedBox(height: 16),
                Text(
                  '미리듣기 추가',
                  style: TextStyle(
                    color: CupertinoColors.systemGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
    );
  }
}

class PreviewPlayerView extends StatefulWidget {
  final String url;

  PreviewPlayerView({required this.url});

  @override
  State<PreviewPlayerView> createState() => _PreviewPlayerViewState();
}

class _PreviewPlayerViewState extends State<PreviewPlayerView> {
  final WebViewController controller = WebViewController();

  @override
  void initState() {
    super.initState();
    controller.loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('미리듣기'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text('편집'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      child: SafeArea(
        child: WebViewWidget(
          controller: controller,
        ),
      ),
    );
  }
}
