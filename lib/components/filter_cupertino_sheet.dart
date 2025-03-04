import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/models/user_collection_classification.dart';

/// FilterButton 위젯: CupertinoActionSheet를 통해 그룹별 필터 옵션을 표시하며,
/// 항목 선택 시 onFilterResult를 호출한 후 모달을 단 한 번 pop하여 닫습니다.
class FilterButton extends StatelessWidget {
  final UserCollectionClassification classification;
  final Function(String) onFilterResult;

  const FilterButton({
    Key? key,
    required this.classification,
    required this.onFilterResult,
  }) : super(key: key);

  Future<void> _openFilterSheet(BuildContext context) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        // 그룹별 액션 위젯을 생성하는 함수
        List<Widget> buildGroupedActions() {
          final List<Widget> actions = [];

          if (classification.genres.isNotEmpty) {
            actions.add(
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Genres',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.left,
                ),
              ),
            );
            actions.addAll(
              classification.genres.map(
                (item) => CupertinoActionSheetAction(
                  onPressed: () {
                    onFilterResult(item);
                    Navigator.pop(context, item); // pop 한 번만 호출
                  },
                  child: Text(item, style: const TextStyle(fontSize: 16)),
                ),
              ),
            );
          }

          if (classification.labels.isNotEmpty) {
            actions.add(
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Labels',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.left,
                ),
              ),
            );
            actions.addAll(
              classification.labels.map(
                (item) => CupertinoActionSheetAction(
                  onPressed: () {
                    onFilterResult(item);
                    Navigator.pop(context, item);
                  },
                  child: Text(item, style: const TextStyle(fontSize: 16)),
                ),
              ),
            );
          }

          if (classification.artists.isNotEmpty) {
            actions.add(
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Artists',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.left,
                ),
              ),
            );
            actions.addAll(
              classification.artists.map(
                (item) => CupertinoActionSheetAction(
                  onPressed: () {
                    onFilterResult(item);
                    Navigator.pop(context, item);
                  },
                  child: Text(item, style: const TextStyle(fontSize: 16)),
                ),
              ),
            );
          }
          return actions;
        }

        return CupertinoActionSheet(
          title: const Text(
            'Filter',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          message: const Text('Select one of the options'),
          actions: buildGroupedActions(),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CupertinoButton(
            onPressed: () => _openFilterSheet(context),
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Filter',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 4),
                Icon(CupertinoIcons.chevron_down),
              ],
            ),
          )
        ],
      ),
    );
  }
}

void main() {
  // 샘플 데이터를 가진 UserCollectionClassification 객체 생성
  final classification = UserCollectionClassification(
    genres: {'Rock', 'Jazz', 'Pop'},
    labels: {'Label A', 'Label B'},
    artists: {'Artist 1', 'Artist 2', 'Artist 3'},
  );

  runApp(
    CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Filter Example'),
        ),
        child: Center(
          child: FilterButton(
            classification: classification,
            onFilterResult: (result) {
              debugPrint('Selected filter: $result');
              // 결과 처리 로직 추가 가능
            },
          ),
        ),
      ),
    ),
  );
}
