import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/dj.dart';

class DJProfileHeader extends StatelessWidget {
  final DJ dj;

  const DJProfileHeader({Key? key, required this.dj}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // DJ 프로필 카드
          Container(
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground.resolveFrom(context),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // DJ 이미지
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    dj.imageURL.toString(),
                    width: 160,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // DJ 이름
                      Text(
                        dj.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // 장르 태그 (예시로 고정값 사용)
                      Row(
                        children: [
                          _buildGenreTag("House"),
                          const SizedBox(width: 8),
                          _buildGenreTag("Techno"),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildGenreTag(String genre) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        genre,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}
