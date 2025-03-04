import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:provider/provider.dart';

import '../model/local/collection_record.dart';
import '../view/collection/collection_edit_page.dart';
import '../view_models/collection_vm.dart';

Widget buildGridItem(
    BuildContext context, CollectionRecord record, CollectionViewModel model) {
  final currencyFormat = NumberFormat.currency(symbol: '₩', decimalDigits: 0);

  return GestureDetector(
    onTap: () {
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
        await Provider.of<CollectionViewModel>(context, listen: false).removeRecord(record);
        await Provider.of<CollectionViewModel>(context, listen: false).fetchUserCollectionsWithRecords();
      }
    },
    child: Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey4.withOpacity(0.5),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 앨범 커버 이미지
          Expanded(
            child: record.record.coverImage.isNotEmpty
                ? ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child: FadeInImage.memoryNetwork(
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
              ),
            )
                : Container(
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey5,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                CupertinoIcons.photo,
                size: 50,
                color: CupertinoColors.systemGrey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              record.record.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.black,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              currencyFormat.format(record.user_collection.purchase_price.toInt()),
              style: const TextStyle(
                fontSize: 14,
                color: CupertinoColors.systemGrey,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}
