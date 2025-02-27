import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  final TextEditingController _conditionController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

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

  void _showConditionPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          color: CupertinoColors.systemBackground,
          child: Column(
            children: [
              Container(
                height: 50,
                color: CupertinoColors.systemGrey6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: Text('취소'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    CupertinoButton(
                      child: Text('확인'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 40,
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      _selectedCondition = _conditionOptions[index];
                    });
                  },
                  children: _conditionOptions.map((condition) {
                    return Center(
                      child: Text(
                        condition,
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final collectionVM = context.watch<CollectionViewModel>();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('컬렉션에 추가', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text('취소', style: TextStyle(color: CupertinoColors.systemRed)),
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
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(16),
                  child: _buildRecordInfo(widget.record),
                ),

                SizedBox(height: 24),

                // 입력 섹션
                Text(
                  '레코드 정보',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
                SizedBox(height: 16),

                // 상태 입력
                Container(
                  decoration: _getInputDecoration(),
                  child: CupertinoButton(
                    padding: EdgeInsets.all(16),
                    onPressed: _showConditionPicker,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedCondition,
                          style: TextStyle(
                            color: CupertinoColors.label,
                            fontSize: 16,
                          ),
                        ),
                        Icon(
                          CupertinoIcons.chevron_down,
                          color: CupertinoColors.systemGrey,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // 노트 입력
                Container(
                  decoration: _getInputDecoration(),
                  child: CupertinoTextField.borderless(
                    controller: _notesController,
                    placeholder: '추가 노트(메모)',
                    padding: EdgeInsets.all(16),
                    maxLines: 3,
                  ),
                ),
                SizedBox(height: 16),

                // 가격 입력
                Container(
                  decoration: _getInputDecoration(),
                  child: CupertinoTextField.borderless(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    placeholder: '구매/추가 가격 (숫자만)',
                    padding: EdgeInsets.all(16),
                    prefix: Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Icon(
                        CupertinoIcons.money_dollar,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // 에러 메시지
                if (collectionVM.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      collectionVM.errorMessage!,
                      style: TextStyle(
                        color: CupertinoColors.systemRed,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                SizedBox(height: 24),

                // 추가 버튼
                SizedBox(
                  height: 50,
                  child: collectionVM.isAdding
                      ? Center(child: CupertinoActivityIndicator())
                      : CupertinoButton.filled(
                    onPressed: () async {
                      final condition = _conditionController.text.trim();
                      final notes = _notesController.text.trim();
                      final price = double.tryParse(
                          _priceController.text.trim()) ??
                          0.0;

                      await collectionVM.addToCollection(
                        widget.record,
                        condition,
                        notes,
                        price,
                      );

                      if (collectionVM.errorMessage == null) {
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
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

  BoxDecoration _getInputDecoration() {
    return BoxDecoration(
      color: CupertinoColors.systemGrey6,
      borderRadius: BorderRadius.circular(12),
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
            child: Icon(
              CupertinoIcons.music_note,
              size: 30,
              color: CupertinoColors.systemGrey,
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                record.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              if (record.artists.isNotEmpty)
                Text(
                  record.artists[0].name,
                  style: TextStyle(
                    color: CupertinoColors.systemGrey,
                    fontSize: 14,
                  ),
                ),
              SizedBox(height: 4),
              Text(
                '년도: ${record.year}',
                style: TextStyle(
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