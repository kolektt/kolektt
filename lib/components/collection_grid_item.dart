import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:provider/provider.dart';

import '../figma_colors.dart';
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
        await Provider.of<CollectionViewModel>(context, listen: false)
            .removeRecord(record);
        await Provider.of<CollectionViewModel>(context, listen: false)
            .fetchUserCollectionsWithRecords();
      }
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 앨범 커버 이미지 영역
        Container(
          width: double.infinity,
          height: 171,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: CupertinoColors.black,
            image: record.record.coverImage.isNotEmpty
                ? DecorationImage(
              image: NetworkImage(record.record.coverImage),
              fit: BoxFit.cover,
            )
                : null,
          ),
          child: record.record.coverImage.isEmpty
              ? Center(
            child: Icon(
              CupertinoIcons.photo,
              size: 50,
              color: CupertinoColors.systemGrey,
            ),
          )
              : null,
        ),
        const SizedBox(height: 8),
        // 컬렉션 제목
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            record.record.title,
            style: FigmaTextStyles()
                .headingheading3
                .copyWith(color: FigmaColors.grey100),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 2),
        // 두번째 텍스트(예시로 "컬렉션" 텍스트 사용)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            "컬렉션",
            style: FigmaTextStyles().bodyxs,
          ),
        ),
        // 하단 행: 구매 가격과 배지 표시
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currencyFormat.format(record.user_collection.purchase_price.toInt()),
                style: FigmaTextStyles().bodyxs,
              ),
              Text(
                "VG+",
                style: FigmaTextStyles()
                    .labelxsbold
                    .copyWith(color: FigmaColors.primary70),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
