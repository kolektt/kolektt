import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:kolektt/view/sellers_list_view.dart';

import '../components/purchase_view.dart';
import '../components/seller_row.dart';
import '../model/record.dart';

// AudioPlayerService: Swift의 AudioPlayer와 유사한 기능을 수행합니다.
class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;

  Future<void> play(String url) async {
    await _audioPlayer.play(UrlSource(url));
    isPlaying = true;
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    isPlaying = false;
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    isPlaying = false;
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}

// RecordDetailView: SwiftUI의 RecordDetailView와 유사한 화면입니다.
class RecordDetailView extends StatefulWidget {
  final Record record;

  const RecordDetailView({Key? key, required this.record}) : super(key: key);

  @override
  _RecordDetailViewState createState() => _RecordDetailViewState();
}

class _RecordDetailViewState extends State<RecordDetailView> {
  final AudioPlayerService audioPlayer = AudioPlayerService();
  bool isPlaying = false;
  bool showingPurchaseSheet = false;

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.record.title),
        previousPageTitle: 'Kolektt',
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 앨범 커버 이미지
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                child: widget.record.coverImageURL != null
                    ? Image.network(
                  widget.record.coverImageURL!,
                  fit: BoxFit.cover,
                )
                    : Container(
                  color: CupertinoColors.systemGrey6,
                  child: const Icon(
                    CupertinoIcons.music_note,
                    size: 64,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 앨범 정보
                    Text(
                      widget.record.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.record.artist,
                      style: const TextStyle(
                        fontSize: 20,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                    if (widget.record.recordDescription != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        widget.record.recordDescription!,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                    const SizedBox(height: 16),
                    // 미리듣기 플레이어 (previewUrl이 존재할 경우)
                    if (widget.record.previewUrl != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemGrey5,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                if (isPlaying) {
                                  audioPlayer.pause();
                                } else {
                                  audioPlayer.play(widget.record.previewUrl!);
                                }
                                setState(() {
                                  isPlaying = !isPlaying;
                                });
                              },
                              child: Icon(
                                isPlaying
                                    ? CupertinoIcons.pause_circle_fill
                                    : CupertinoIcons.play_circle_fill,
                                size: 44,
                                color: CupertinoColors.activeBlue,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  '미리듣기',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '30초',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: CupertinoColors.systemGrey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                    // 판매자 목록
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '판매자 목록',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${widget.record.sellersCount}개의 매물',
                          style: const TextStyle(
                            fontSize: 14,
                            color: CupertinoColors.systemGrey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: List.generate(3, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: SellerRow(
                            sellerName: 'DJ Name ${index + 1}',
                            price: 50000 + (index * 5000),
                            condition: 'VG+',
                            onPurchase: () {
                              _showPurchaseSheet();
                            },
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: CupertinoButton(
                        color: CupertinoColors.activeBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) =>
                                  SellersListView(record: widget.record),
                            ),
                          );
                        },
                        child: const Text(
                          '전체 판매자 보기',
                          style: TextStyle(color: CupertinoColors.activeBlue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // 화면 떠날 때 미리듣기 정지
      // (didChangeDependencies 혹은 onDisappear와 유사한 역할)
    );
  }

  void _showPurchaseSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => PurchaseView(record: widget.record),
    );
  }
}
