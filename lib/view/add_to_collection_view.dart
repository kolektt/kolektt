import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../model/discogs/discogs_record.dart';
import '../view_models/collection_vm.dart';

class AddToCollectionScreen extends StatefulWidget {
  final DiscogsRecord record;

  const AddToCollectionScreen({
    Key? key,
    required this.record,
  }) : super(key: key);

  @override
  State<AddToCollectionScreen> createState() => _AddToCollectionScreenState();
}

class _AddToCollectionScreenState extends State<AddToCollectionScreen> {
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _newTagController = TextEditingController();

  final List<String> _conditionOptions = [
    'Mint (M)',
    'Near Mint (NM)',
    'Very Good Plus (VG+)',
    'Very Good (VG)',
    'Good Plus (G+)',
    'Good (G)',
    'Fair (F)',
    'Poor (P)'
  ];

  String _selectedCondition = 'Very Good Plus (VG+)'; // 기본값

  DateTime? _purchaseDate;
  List<String> _tagList = [];

  void _showConditionPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text('상태 선택'),
          message: const Text('원하는 상태를 선택해주세요.'),
          actions: _conditionOptions.map((option) {
            return CupertinoActionSheetAction(
              child: Text(option),
              onPressed: () {
                setState(() {
                  _selectedCondition = option;
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
                  initialDateTime: _purchaseDate ?? DateTime.now(),
                  maximumDate: DateTime.now(),
                  onDateTimeChanged: (date) {
                    setState(() {
                      _purchaseDate = date;
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
                _tagList.remove(tag);
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
  void dispose() {
    _notesController.dispose();
    _priceController.dispose();
    _newTagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final collectionVM = context.watch<CollectionViewModel>();

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
                          _selectedCondition,
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
                    controller: _priceController,
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
                          _purchaseDate != null
                              ? DateFormat('yyyy년 MM월 dd일').format(_purchaseDate!)
                              : '구매일 선택',
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
                    controller: _notesController,
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
                      if (_tagList.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          children: _tagList.map((tag) => _buildEditableTag(tag)).toList(),
                        ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: CupertinoTextField(
                              controller: _newTagController,
                              placeholder: '새 태그 입력',
                              padding: const EdgeInsets.all(16),
                            ),
                          ),
                          CupertinoButton(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: const Text('추가'),
                            onPressed: () {
                              final newTag = _newTagController.text.trim();
                              if (newTag.isNotEmpty && !_tagList.contains(newTag)) {
                                setState(() {
                                  _tagList.add(newTag);
                                });
                                _newTagController.clear();
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
                      final condition = _selectedCondition;
                      // final conditionNote = _conditionNoteController.text.trim();
                      final priceText = _priceController.text.trim();

                      // 모든 필수 항목이 입력되었는지 확인
                      if (condition.isEmpty ||
                          priceText.isEmpty ||
                          _purchaseDate == null) {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: const Text('입력 오류'),
                              content: const Text('모든 항목을 작성해주세요.'),
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

                      final price = double.tryParse(priceText) ?? 0.0;
                      if (price == 0.0) {
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
                      await collectionVM.addToCollection(
                        widget.record,    // 레코드 정보
                        condition,        // 상태
                        price,            // 구매가
                        _purchaseDate!,    // 구매일
                        _tagList,         // 태그 리스트
                      );

                      if (collectionVM.errorMessage == null) {
                        collectionVM.fetchUserCollectionsWithRecords();
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

  Widget _buildRecordInfo(DiscogsRecord record) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: record.thumb.isNotEmpty
              ? Image.network(
            record.thumb,
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
              if (record.artists.isNotEmpty)
                Text(
                  record.artists[0].name,
                  style: const TextStyle(
                    color: CupertinoColors.systemGrey,
                    fontSize: 14,
                  ),
                ),
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
