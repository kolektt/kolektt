import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kolektt/view/record_detail_view.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

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
                      record.record.resourceUrl = "https://api.discogs.com/releases/${record.record.id}";

                      return GestureDetector(
                        onTap: () {
                          debugPrint("Record tapped: ${record.record.toJson()}");
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => RecordDetailView(record: record.record),
                            ),
                          );
                        },
                        onLongPress: () async {
                          // 삭제 확인 다이얼로그 표시
                          final confirmed = await showCupertinoDialog<bool>(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: Text("삭제 확인"),
                                content: Text("이 컬렉션 아이템을 삭제하시겠습니까?"),
                                actions: [
                                  CupertinoDialogAction(
                                    child: Text("취소"),
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    child: Text("삭제"),
                                    isDestructiveAction: true,
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                          if (confirmed == true) {
                            await Provider.of<CollectionViewModel>(context, listen: false).removeRecord(record);
                          }
                        },
                        child: Card(
                          elevation: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 앨범 커버 이미지: URL이 없으면 placeholder 처리
                              Expanded(
                                child: record.record.coverImage.isNotEmpty
                                    ? FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: record.record.coverImage,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  imageErrorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 50,
                                      height: 50,
                                      color: CupertinoColors.systemGrey5,
                                      child: const Icon(
                                        CupertinoIcons.music_note,
                                        color: CupertinoColors.systemGrey2,
                                      ),
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
                                  record.record.title,
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
                                  record.record.year.toString(),
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
