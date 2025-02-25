import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../view/home_view.dart';
import '../model/record.dart';
import '../view/record_detail_view.dart';
import 'home_view.dart';
import 'magzine_detail_view.dart';


// DJ 프로필 헤더
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

// 컨텐츠 섹션
class DJContentSection extends StatelessWidget {
  final InterviewContent content;

  const DJContentSection({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (content.type) {
      case InterviewContentType.text:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            content.text,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
        );
      case InterviewContentType.quote:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: CupertinoColors.systemGrey6,
            child: Text(
              content.text,
              style: const TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        );
      case InterviewContentType.recordHighlight:
        return DJRecordSection(content: content);
      default:
        return const SizedBox();
    }
  }
}

// 레코드 섹션
class DJRecordSection extends StatelessWidget {
  final InterviewContent content;

  const DJRecordSection({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 타이틀
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            '추천 레코드',
            style: CupertinoTheme.of(context)
                .textTheme
                .navTitleTextStyle
                .copyWith(fontSize: 18),
          ),
        ),
        // 수평 스크롤 레코드 카드 리스트
        SizedBox(
          height: 280,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: content.records.length,
            separatorBuilder: (context, index) =>
            const SizedBox(width: 20),
            itemBuilder: (context, index) {
              return DJRecordCard(record: content.records[index]);
            },
          ),
        ),
      ],
    );
  }
}

// 레코드 카드 컴포넌트
class DJRecordCard extends StatelessWidget {
  final Record record;

  const DJRecordCard({Key? key, required this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        // RecordDetailView로 네비게이션 (미리 구현되어 있다고 가정)
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => RecordDetailView(record: record),
          ),
        );
      },
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground.resolveFrom(context),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 레코드 커버 이미지
            if (record.coverImageURL != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  record.coverImageURL!,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 레코드 제목
                  Text(
                    record.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // 아티스트 이름
                  Text(
                    record.artist,
                    style: TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.systemGrey.resolveFrom(context),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// 메인 뷰
class DJsPickDetailView extends StatelessWidget {
  final DJ dj;

  const DJsPickDetailView({Key? key, required this.dj}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        previousPageTitle: 'Kolektt',
        middle: Text('DJ 상세'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DJProfileHeader(dj: dj),
              ...dj.interviewContents
                  .map((content) => DJContentSection(content: content))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}


// MARK: - App Entry Point
void main() {
  runApp(const DJsPickApp());
}

class DJsPickApp extends StatelessWidget {
  const DJsPickApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'DJs Pick',
      theme: const CupertinoThemeData(
        brightness: Brightness.light,
      ),
      home: DJsPickDetailView(dj: DJ.sampleData.first),
    );
  }
}
