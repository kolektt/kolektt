import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/analytics_section.dart';
import '../view_models/collection_vm.dart';
import 'auto_album_detection_view.dart';

class CollectionView extends StatefulWidget {
  @override
  _CollectionViewState createState() => _CollectionViewState();
}

class _CollectionViewState extends State<CollectionView> {
  @override
  void initState() {
    super.initState();
    // Provider를 통해 데이터를 불러옵니다.
    Provider.of<CollectionViewModel>(context, listen: false)
        .fetchUserCollectionsWithRecords();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("컬렉션"),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => AutoAlbumDetectionScreen(),
                  ),
                );
              },
              icon: Icon(
                CupertinoIcons.add_circled_solid,
                size: 32,
                color: CupertinoColors.black,
              )),
          onPressed: () {
            // 추가 메뉴 처리 (CupertinoActionSheet 등을 사용)
          },
        ),
      ),
      child: SafeArea(
        child: Consumer<CollectionViewModel>(
          builder: (context, model, child) {
            if (model.isLoading) {
              return Center(child: CupertinoActivityIndicator());
            }
            if (model.collectionRecords.isEmpty) {
              return Center(child: Text("컬렉션이 없습니다."));
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 컬렉션 현황 부분: analytics 데이터를 기반으로 통계 정보 표시
                  AnalyticsSection(records: model.collectionRecords),
                  // 일정 간격 추가
                  SizedBox(height: 16),
                  // 레코드 목록 (GridView)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: model.collectionRecords.length,
                    itemBuilder: (context, index) {
                      final record = model.collectionRecords[index];
                      return GestureDetector(
                        onTap: () {
                          // RecordDetailView로 이동 (필요 시 구현)
                          // Navigator.push(context, CupertinoPageRoute(builder: (_) => RecordDetailView(record: record)));
                        },
                        child: Card(
                          elevation: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 앨범 커버 이미지: URL이 없으면 placeholder 처리
                              Expanded(
                                child: record.coverImage.isNotEmpty
                                    ? Image.network(
                                  record.coverImage,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder:
                                      (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey,
                                      child: Icon(Icons.error),
                                    );
                                  },
                                )
                                    : Container(
                                  color: Colors.grey,
                                  child: Icon(Icons.image),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  record.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  record.year.toString(),
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              SizedBox(height: 8),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
