import 'package:flutter/cupertino.dart';
import 'package:kolektt/data/models/discogs_record.dart';

class ArtistDetailView extends StatelessWidget {
  final Artist artist;
  const ArtistDetailView({Key? key, required this.artist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground,
        border: null,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.back),
          onPressed: null, // Add navigation function here
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Artist Header Section with Image and Name
              Container(
                color: CupertinoColors.systemOrange.withOpacity(0.7),
                height: 300,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text(
                        'David',
                        style: TextStyle(
                          color: CupertinoColors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Anderson',
                        style: TextStyle(
                          color: CupertinoColors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Genre Tags and Album Count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Wrap(
                  spacing: 10,
                  children: [
                    _buildTag('Alternative Rock'),
                    _buildTag('RnB'),
                    _buildTag('24 Albums'),
                  ],
                ),
              ),

              // Korean Text - "연도 선택" (Year Selection)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: CupertinoColors.systemGrey4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('연도 선택', style: TextStyle(fontSize: 16)),
                        Icon(CupertinoIcons.chevron_down, color: CupertinoColors.systemGrey),
                      ],
                    ),
                  ),
                ),
              ),

              // Album Grid
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildAlbumItem('Midnight Echoes', '2023', 'LP', _getMidnightEchoesImage())),
                        const SizedBox(width: 12),
                        Expanded(child: _buildAlbumItem('Rainbow', '2020', '12"', _getRainbowImage())),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildAlbumItem('Midnight Echoes', '2023', '7"', _getMidnightEchoesImage())),
                        const SizedBox(width: 12),
                        Expanded(child: _buildAlbumItem('Rainbow', '2020', 'Tape', _getRainbowBackgroundImage())),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildAlbumItem(String title, String year, String format, Widget image) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AspectRatio(
            aspectRatio: 1,
            child: image,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              year,
              style: const TextStyle(
                color: CupertinoColors.systemGrey,
                fontSize: 14,
              ),
            ),
            Text(
              format,
              style: const TextStyle(
                color: CupertinoColors.activeBlue,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Placeholder widgets for album images
  Widget _getMidnightEchoesImage() {
    return Container(
      color: CupertinoColors.systemIndigo,
      child: Center(
        child: Icon(
          CupertinoIcons.person_fill,
          color: CupertinoColors.systemPurple.withOpacity(0.7),
          size: 64,
        ),
      ),
    );
  }

  Widget _getRainbowImage() {
    return Container(
      color: CupertinoColors.systemPink.withOpacity(0.3),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(CupertinoIcons.person_2_fill, color: CupertinoColors.black, size: 14),
            SizedBox(width: 2),
            Icon(CupertinoIcons.person_2_fill, color: CupertinoColors.black, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _getRainbowBackgroundImage() {
    return Container(
      color: CupertinoColors.systemBlue.withOpacity(0.3),
      child: Center(
        child: Icon(
          CupertinoIcons.house_fill,
          color: CupertinoColors.systemBlue,
          size: 32,
        ),
      ),
    );
  }
}
