import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';

import 'model/record.dart';

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

class RecordDetailView extends StatefulWidget {
  final Record record;

  const RecordDetailView({Key? key, required this.record}) : super(key: key);

  @override
  _RecordDetailViewState createState() => _RecordDetailViewState();
}

class _RecordDetailViewState extends State<RecordDetailView> {
  final AudioPlayerService _audioPlayer = AudioPlayerService();
  bool isPlaying = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.record.title),
        previousPageTitle: '뒤로',
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width,
                  width: double.infinity,
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
                          fontSize: 18,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                      if (widget.record.notes != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          widget.record.notes!,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                      const SizedBox(height: 24),
                      _buildSellersList(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSellersList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              '판매자 목록',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '1개의 매물',
              style: TextStyle(
                fontSize: 14,
                color: CupertinoColors.systemGrey,
              ),
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SellerRow(
                sellerName: 'DJ Name ${index + 1}',
                price: 50000 + (index * 5000),
                condition: 'VG+',
                onPurchase: () {
                  _showPurchaseSheet(context);
                },
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: CupertinoButton(
            color: CupertinoColors.activeBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => SellersListView(record: widget.record),
                ),
              );
            },
            child: const Text(
              '전체 판매자 보기',
              style: TextStyle(color: CupertinoColors.activeBlue),
            ),
          ),
        ),
        const SizedBox(height: 64)
      ],
    );
  }

  void _showPurchaseSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => PurchaseView(record: widget.record),
    );
  }
}

class SellerRow extends StatelessWidget {
  final String sellerName;
  final int price;
  final String condition;
  final VoidCallback onPurchase;

  const SellerRow({
    Key? key,
    required this.sellerName,
    required this.price,
    required this.condition,
    required this.onPurchase,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: CupertinoColors.systemGrey,
            ),
            child: const Icon(
              CupertinoIcons.person_solid,
              color: CupertinoColors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sellerName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '$price원',
                      style: const TextStyle(
                        color: CupertinoColors.activeBlue,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('•'),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        condition,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          CupertinoButton(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            color: CupertinoColors.activeBlue,
            borderRadius: BorderRadius.circular(8),
            onPressed: onPurchase,
            child: const Text('구매', style: TextStyle(color: CupertinoColors.white)),
          ),
        ],
      ),
    );
  }
}

class SellersListView extends StatelessWidget {
  final Record record;

  const SellersListView({Key? key, required this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('판매자 목록'),
        previousPageTitle: '뒤로',
      ),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 16),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: SellerRow(
              sellerName: 'DJ Name ${index + 1}',
              price: 50000 + (index * 5000),
              condition: 'VG+',
              onPurchase: () {},
            ),
          );
        },
      ),
    );
  }
}

class PurchaseView extends StatelessWidget {
  final Record record;

  const PurchaseView({Key? key, required this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: const Text('구매하기'),
      message: const Text('구매 진행 중...'),
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.pop(context),
        child: const Text('취소'),
      ),
    );
  }
}