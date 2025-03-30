import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:kolektt/data/models/discogs_search_response.dart';
import 'package:provider/provider.dart';

import '../domain/entities/record_condition.dart';
import '../view_models/add_collection_vm.dart';
import '../view_models/collection_vm.dart';

class AddCollectionView extends StatefulWidget {
  final DiscogsSearchItem record;

  const AddCollectionView({
    Key? key,
    required this.record,
  }) : super(key: key);

  @override
  State<AddCollectionView> createState() => _AddCollectionViewState();
}

class _AddCollectionViewState extends State<AddCollectionView> {
  void _showConditionPicker() {
    final model = context.read<AddCollectionViewModel>();
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text('상태 선택'),
          message: const Text('원하는 상태를 선택해주세요.'),
          actions: RecordCondition.values.map((option) {
            return CupertinoActionSheetAction(
              child: Text(option.name),
              onPressed: () {
                setState(() {
                  model.selectedCondition = option;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
          cancelButton: CupertinoActionSheetAction(
            child: const Text('취소'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  void _showDatePicker() {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final model = context.read<AddCollectionViewModel>();
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Container(
          height: 300,
          decoration: BoxDecoration(
            color: isDark ? CupertinoColors.systemBackground.darkColor : CupertinoColors.systemBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: isDark ? CupertinoColors.systemBackground.darkColor : CupertinoColors.systemBackground,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: Text(
                        '취소',
                        style: TextStyle(color: isDark ? CupertinoColors.systemRed : CupertinoColors.systemRed),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    CupertinoButton(
                      child: Text(
                        '확인',
                        style: TextStyle(color: isDark ? CupertinoColors.systemBlue : CupertinoColors.systemBlue),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: model.purchaseDate,
                  maximumDate: DateTime.now(),
                  onDateTimeChanged: (date) {
                    setState(() {
                      model.purchaseDate = date;
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEditableTag(String tag) {
    final model = context.read<AddCollectionViewModel>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey4,
        border: Border.all(color: CupertinoColors.systemGrey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tag,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () {
              setState(() {
                model.tagList.remove(tag);
              });
            },
            child: const Icon(
              CupertinoIcons.clear,
              size: 16,
              color: CupertinoColors.systemGrey,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _getInputDecoration() {
    return BoxDecoration(
      color: CupertinoColors.systemGrey6,
      borderRadius: BorderRadius.circular(12),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<AddCollectionViewModel>().record = widget.record;
  }

  @override
  void dispose() {
    final model = context.read<AddCollectionViewModel>();
    model.notesController.dispose();
    model.priceController.dispose();
    model.newTagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final collectionVM = context.watch<AddCollectionViewModel>();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('컬렉션에 추가', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('취소', style: TextStyle(color: CupertinoColors.systemRed)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 앨범 카드
                Container(
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: CupertinoColors.systemGrey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: _buildRecordInfo(widget.record),
                ),

                const SizedBox(height: 24),

                // 입력 섹션 타이틀
                const Text(
                  '레코드 정보',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
                const SizedBox(height: 16),

                // 1. 상태 선택
                Container(
                  decoration: _getInputDecoration(),
                  child: CupertinoButton(
                    padding: const EdgeInsets.all(16),
                    onPressed: _showConditionPicker,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          collectionVM.selectedCondition.name,
                          style: const TextStyle(
                            color: CupertinoColors.label,
                            fontSize: 16,
                          ),
                        ),
                        const Icon(
                          CupertinoIcons.chevron_down,
                          color: CupertinoColors.systemGrey,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 3. 구매가 입력
                Container(
                  decoration: _getInputDecoration(),
                  child: CupertinoTextField.borderless(
                    controller: collectionVM.priceController,
                    keyboardType: TextInputType.number,
                    placeholder: '구매/추가 가격 (숫자만)',
                    padding: const EdgeInsets.all(16),
                    prefix: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: const Icon(
                        CupertinoIcons.money_dollar,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 4. 구매일 선택
                Container(
                  decoration: _getInputDecoration(),
                  child: CupertinoButton(
                    padding: const EdgeInsets.all(16),
                    onPressed: _showDatePicker,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('yyyy년 MM월 dd일').format(collectionVM.purchaseDate),
                          style: const TextStyle(
                            color: CupertinoColors.label,
                            fontSize: 16,
                          ),
                        ),
                        const Icon(
                          CupertinoIcons.calendar,
                          color: CupertinoColors.systemGrey,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 5. 메모 입력 (추가 노트)
                Container(
                  decoration: _getInputDecoration(),
                  child: CupertinoTextField.borderless(
                    controller: collectionVM.notesController,
                    placeholder: '추가 노트(메모)',
                    padding: const EdgeInsets.all(16),
                    maxLines: 3,
                  ),
                ),
                const SizedBox(height: 16),

                // 6. 태그 입력 섹션
                Container(
                  decoration: _getInputDecoration(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '태그',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (collectionVM.tagList.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          children: collectionVM.tagList.map((tag) => _buildEditableTag(tag)).toList(),
                        ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: CupertinoTextField(
                              controller: collectionVM.newTagController,
                              placeholder: '새 태그 입력',
                              padding: const EdgeInsets.all(16),
                            ),
                          ),
                          CupertinoButton(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: const Text('추가'),
                            onPressed: () {
                              final newTag = collectionVM.newTagController.text.trim();
                              if (newTag.isNotEmpty && !collectionVM.tagList.contains(newTag)) {
                                setState(() {
                                  collectionVM.tagList.add(newTag);
                                });
                                collectionVM.newTagController.clear();
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 에러 메시지
                if (collectionVM.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      collectionVM.errorMessage!,
                      style: const TextStyle(
                        color: CupertinoColors.systemRed,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                const SizedBox(height: 24),

                // 추가 버튼
                SizedBox(
                  height: 50,
                  child: collectionVM.isAdding
                      ? const Center(child: CupertinoActivityIndicator())
                      : CupertinoButton.filled(
                    onPressed: () async {
                      final condition = collectionVM.selectedCondition;

                      // 모든 필수 항목이 입력되었는지 확인
                      // if (condition.isEmpty) {
                      //   showCupertinoDialog(
                      //     context: context,
                      //     builder: (context) {
                      //       return CupertinoAlertDialog(
                      //         title: const Text('입력 오류'),
                      //         content: const Text('모든 항목을 작성해주세요.'),
                      //         actions: [
                      //           CupertinoDialogAction(
                      //             child: const Text('확인'),
                      //             onPressed: () => Navigator.pop(context),
                      //           ),
                      //         ],
                      //       );
                      //     },
                      //   );
                      //   return;
                      // }

                      if (collectionVM.price == 0.0) {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: const Text('입력 오류'),
                              content: const Text('유효한 가격을 입력해주세요.'),
                              actions: [
                                CupertinoDialogAction(
                                  child: const Text('확인'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            );
                          },
                        );
                        return;
                      }

                      // ViewModel의 addToCollection 메서드가 추가 필드들을 받도록 업데이트 되어있다고 가정합니다.
                      await collectionVM.addToCollection();

                      if (collectionVM.errorMessage == null) {
                        context.read<CollectionViewModel>().fetch();
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      '컬렉션에 추가',
                      style: TextStyle(fontSize: 16),
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecordInfo(DiscogsSearchItem record) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: record.coverImage.isNotEmpty
              ? Image.network(
            record.coverImage,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          )
              : Container(
            width: 80,
            height: 80,
            color: CupertinoColors.systemGrey5,
            child: const Icon(
              CupertinoIcons.music_note,
              size: 30,
              color: CupertinoColors.systemGrey,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              const SizedBox(height: 4),
              Text(
                '${record.year}년',
                style: const TextStyle(
                  color: CupertinoColors.systemGrey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
