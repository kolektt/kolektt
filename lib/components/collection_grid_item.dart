import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../model/local/collection_record.dart';
import '../view/collection/collection_edit_page.dart';
import '../view_models/collection_vm.dart';

Widget buildGridItem(
    context, CollectionRecord record, CollectionViewModel model) {
  return GestureDetector(
    onTap: () {
      // debugPrint("Record tapped: ${record.record.toJson()}");
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
