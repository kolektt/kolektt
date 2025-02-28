import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kolektt/view/collection/collection_edit_page.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../components/analytics_section.dart';
import '../../view_models/collection_vm.dart';
import '../auto_album_detection_view.dart';

class CollectionView extends StatefulWidget {
  const CollectionView({Key? key}) : super(key: key);

  @override
  _CollectionViewState createState() => _CollectionViewState();
}

class _CollectionViewState extends State<CollectionView> {
  @override
  void initState() {
    super.initState();
    // Fetch collection records on initialization.
    Provider.of<CollectionViewModel>(context, listen: false)
        .fetchUserCollectionsWithRecords();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("컬렉션"),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (_) => AutoAlbumDetectionScreen(),
              ),
            );
          },
          child: const Icon(
            CupertinoIcons.add_circled_solid,
            size: 32,
            color: CupertinoColors.black,
          ),
        ),
      ),
      child: SafeArea(
        child: Consumer<CollectionViewModel>(
          builder: (context, model, child) {
            if (model.isLoading) {
              return const Center(child: CupertinoActivityIndicator());
            }
            if (model.collectionRecords.isEmpty) {
              return const Center(child: Text("컬렉션이 없습니다."));
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnalyticsSection(records: model.collectionRecords),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: model.collectionRecords.length,
                    itemBuilder: (context, index) {
                      final record = model.collectionRecords[index];
                      record.record.resourceUrl =
                      "https://api.discogs.com/releases/${record.record.id}";
                      return _buildGridItem(record, model);
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

  Widget _buildGridItem(dynamic record, CollectionViewModel model) {
    return GestureDetector(
      onTap: () {
        debugPrint("Record tapped: ${record.record.toJson()}");
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (_) => CollectionEditPage(
              collection: record,
              onSave: (editedCollection) {
                model.updateRecord(editedCollection).then((_) {
                  model.fetchUserCollectionsWithRecords();
                  Navigator.pop(context);
                });
              },
            ),
          ),
        );
      },
      onLongPress: () async {
        final confirmed = await showCupertinoDialog<bool>(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text("삭제 확인"),
              content: const Text("이 컬렉션 아이템을 삭제하시겠습니까?"),
              actions: [
                CupertinoDialogAction(
                  child: const Text("취소"),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                CupertinoDialogAction(
                  child: const Text("삭제"),
                  isDestructiveAction: true,
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            );
          },
        );
        if (confirmed == true) {
          await Provider.of<CollectionViewModel>(context, listen: false)
              .removeRecord(record);
          await Provider.of<CollectionViewModel>(context, listen: false)
              .fetchUserCollectionsWithRecords();
        }
      },
      child: Card(
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Album cover image
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
                child: const Icon(Icons.image),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                record.record.title,
                style: const TextStyle(
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
                "₩ ${record.user_collection.purchase_price.toInt()}",
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
