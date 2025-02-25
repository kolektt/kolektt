import 'package:flutter/cupertino.dart';

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
