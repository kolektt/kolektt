import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kolektt/figma_colors.dart';
import 'package:provider/provider.dart';

import '../data/models/user_collection_classification.dart';
import '../view_models/collection_vm.dart';

/// 필터 화면 위젯
class FilterScreen extends StatefulWidget {
  final UserCollectionClassification initialFilter;
  final Function(UserCollectionClassification) onFilterResult;

  const FilterScreen({
    Key? key,
    required this.initialFilter,
    required this.onFilterResult,
  }) : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  UserCollectionClassification _filter = UserCollectionClassification.initial();

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('필터 레코드'),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16.0),
                    // 컨디션 섹션: 미디어 및 슬리브 컨디션
                    _buildSectionTitle('컨디션'),
                    _buildConditionSection(
                      label: '미디어 컨디션',
                      currentValue: _filter.mediaCondition,
                      options: _filter.mediaConditions,
                      onChanged: (value) {
                        setState(() {
                          _filter = _filter.copyWith(mediaCondition: value);
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    // _buildConditionSection(
                    //   label: '슬리브 컨디션',
                    //   currentValue: _filter.sleeveCondition,
                    //   options: _filter.sleeveConditions,
                    //   onChanged: (value) {
                    //     setState(() {
                    //       _filter = _filter.copyWith(sleeveCondition: value);
                    //     });
                    //   },
                    // ),
                    // 장르 섹션
                    _buildSectionTitle('장르'),
                    _buildDropdownButton(
                      title: '장르 선택',
                      currentValue: _filter.genre,
                      options: _filter.genres,
                      onChanged: (value) {
                        setState(() {
                          _filter = _filter.copyWith(genre: value);
                        });
                      },
                    ),
                    // 출시년도 슬라이더 섹션
                    _buildSectionTitle('출시년도'),
                    _buildYearRangeSlider(),
                    // 정렬 옵션 섹션
                    _buildSectionTitle('정렬'),
                    _buildDropdownButton(
                      title: '정렬 옵션 선택',
                      currentValue: _filter.sortOption,
                      options: _filter.sortOptions,
                      onChanged: (value) {
                        setState(() {
                          _filter = _filter.copyWith(sortOption: value);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
      child: Text(
        title,
        style: FigmaTextStyles().headingheading5.copyWith(color: FigmaColors.grey90),
      ),
    );
  }

  /// 공통 드롭다운 버튼 위젯
  Widget _buildDropdownButton({
    required String title,
    required String currentValue,
    required List<String> options,
    required Function(String) onChanged,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => _showSingleSelectPicker(
        title: title,
        options: options,
        currentValue: currentValue,
        onChanged: onChanged,
      ),
      child: Container(
        height: 48.0,
        decoration: BoxDecoration(
          border: Border.all(color: CupertinoColors.systemGrey4),
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              currentValue,
              style: FigmaTextStyles().bodymd.copyWith(color: FigmaColors.grey100),
            ),
            const Icon(
              CupertinoIcons.chevron_down,
              size: 16,
              color: CupertinoColors.systemGrey,
            ),
          ],
        ),
      ),
    );
  }

  /// 컨디션 섹션을 위한 위젯 (라벨 + 드롭다운)
  Widget _buildConditionSection({
    required String label,
    required String currentValue,
    required List<String> options,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: CupertinoColors.systemGrey),
        ),
        const SizedBox(height: 8.0),
        _buildDropdownButton(
          title: label,
          currentValue: currentValue,
          options: options,
          onChanged: onChanged,
        ),
      ],
    );
  }

  /// 단일 선택 액션 시트를 보여주는 메서드
  Future<void> _showSingleSelectPicker({
    required String title,
    required List<String> options,
    required String currentValue,
    required Function(String) onChanged,
  }) async {
    final result = await showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(
          title,
          style: FigmaTextStyles().bodysm.copyWith(color: FigmaColors.grey60),
      ),
        actions: options
            .map((option) => CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context, option),
          child: Text(option),
        ))
            .toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );

    if (result != null) {
      onChanged(result);
    }
  }

  /// 출시년도 범위 슬라이더
  Widget _buildYearRangeSlider() {
    return Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 현재 시작년도와 종료년도를 표시
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${_filter.startYear}', style: const TextStyle(fontSize: 16)),
              Text('${_filter.endYear}', style: const TextStyle(fontSize: 16)),
            ],
          ),
          RangeSlider(
            min: 1900,
            max: DateTime.now().year.toDouble(),
            activeColor: const Color(0xff2654FF),
            inactiveColor: const Color(0xffEAEFFF),
            values: RangeValues(
              _filter.startYear.toDouble(),
              _filter.endYear.toDouble(),
            ),
            onChanged: (RangeValues values) {
              setState(() {
                int start = values.start.round();
                int end = values.end.round();
                if (start > end) {
                  start = end;
                }
                _filter = _filter.copyWith(
                  startYear: start,
                  endYear: end,
                );
              });
            },
          ),
        ],
      ),
    );
  }

  /// 하단의 Reset 및 결과 버튼
  Widget _buildBottomButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Reset All 버튼
          Expanded(
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                border: Border.all(color: FigmaColors.grey50),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: CupertinoButton(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                borderRadius: BorderRadius.circular(8.0),
                color: CupertinoColors.white,
                child: Text(
                  'Reset All',
                  style: FigmaTextStyles().labelmdbold.copyWith(color: FigmaColors.grey50),
                ),
                onPressed: () {
                  setState(() {
                    _filter = _filter.copyWith(
                      mediaCondition: 'All',
                      sleeveCondition: 'All',
                      genre: 'All',
                      startYear: 1900,
                      endYear: 2025,
                      sortOption: '최신순',
                    );
                  });
                },
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          // Show Results 버튼
          Expanded(
            child: SizedBox(
              height: 56,
              child: CupertinoButton(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                borderRadius: BorderRadius.circular(8.0),
                color: const Color(0xff2654FF),
                child: Text(
                  'Show Results',
                  style: FigmaTextStyles().labelmdbold.copyWith(color: CupertinoColors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop(_filter);
                  widget.onFilterResult(_filter);
                  debugPrint('Filter: $_filter');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}