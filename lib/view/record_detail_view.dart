import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../components/purchase_view.dart';
import '../components/seller_row.dart';
import '../model/discogs_record.dart';
import '../view_models/record_detail_vm.dart';

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

// RecordDetailView: 이제 DiscogsRecord를 사용하며,
// previewUrl와 sellersCount가 없으므로 미리듣기 및 매물 수 표시를 제외합니다.
class RecordDetailView extends StatefulWidget {
  final DiscogsRecord record;

  const RecordDetailView({Key? key, required this.record}) : super(key: key);

  @override
  _RecordDetailViewState createState() => _RecordDetailViewState();
}

class _RecordDetailViewState extends State<RecordDetailView> {
  final AudioPlayerService audioPlayer = AudioPlayerService();
  bool isPlaying = false;

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RecordDetailViewModel(baseRecord: widget.record),
      builder: (context, _) {
        return Consumer<RecordDetailViewModel>(
          builder: (context, model, child) {
            return AnimatedSwitcher(
              // [AnimatedSwitcher]가 교체되는 위젯을 구분할 수 있도록 key를 지정하거나,
              // child 자체가 바뀌도록 구성해주면 됩니다.
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                // 위젯 전환 시 페이드 효과
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              // 로딩 상태 여부에 따라 다른 위젯을 child로 넘겨주기
              child: model.isLoading
                  ? CupertinoPageScaffold(
                key: const ValueKey('loadingPage'),
                navigationBar: const CupertinoNavigationBar(
                  middle: Text('로딩중...'),
                ),
                child: const Center(
                  child: CupertinoActivityIndicator(),
                ),
              )
                  : CupertinoPageScaffold(
                key: const ValueKey('loadedPage'),
                navigationBar: CupertinoNavigationBar(
                  middle: Text(model.detailedRecord?.title ?? '상세정보'),
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
                          child: (model.detailedRecord?.images.isNotEmpty ?? false)
                              ? Image.network(
                            model.detailedRecord!.images.first.uri,
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
                                model.detailedRecord!.title,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                model.detailedRecord!.artists.isNotEmpty
                                          ? model.detailedRecord!.artists
                                              .map((artist) => artist.name)
                                              .join(', ')
                                          : '알 수 없음',
                                      style: const TextStyle(
                                  fontSize: 20,
                                  color: CupertinoColors.systemGrey,
                                ),
                              ),
                              const SizedBox(height: 16),
                              // 판매자 목록
                              const Text(
                                '판매자 목록',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
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
                                    // 전체 판매자 목록 화면으로 이동
                                  },
                                  child: const Text(
                                    '전체 판매자 보기',
                                    style: TextStyle(
                                      color: CupertinoColors.activeBlue,
                                    ),
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
              ),
            );
          },
        );
      },
    );
  }

  void _showPurchaseSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => PurchaseView(record: widget.record),
    );
  }
}