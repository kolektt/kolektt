import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/models/user_collection_classification.dart';

/// FilterButton 위젯: CupertinoActionSheet를 통해 그룹별 필터 옵션을 표시하며,
/// 항목 선택 시 onFilterResult를 호출한 후 모달을 단 한 번 pop하여 닫습니다.
class FilterButton extends StatelessWidget {
  final UserCollectionClassification classification;
  final Function(UserCollectionClassification) onFilterResult;

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
                    onFilterResult(
                      UserCollectionClassification(
                        genres: {item},
                        labels: <String>{},
                        artists: <String>{},
                      ),
                    );
                    Navigator.pop(context);
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
                    onFilterResult(
                      UserCollectionClassification(
                        genres: <String>{},
                        labels: {item},
                        artists: <String>{},
                      ),
                    );
                    Navigator.pop(context);
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
                    onFilterResult(
                      UserCollectionClassification(
                        genres: <String>{},
                        labels: <String>{},
                        artists: {item},
                      ),
                    );
                    Navigator.pop(context);
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
          actions: [
            ...buildGroupedActions(),
            CupertinoActionSheetAction(
              onPressed: () {
                // Clear Filter: 빈 UserCollectionClassification 전달
                onFilterResult(
                  UserCollectionClassification(
                    genres: <String>{},
                    labels: <String>{},
                    artists: <String>{},
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text(
                'Clear Filter',
                style: TextStyle(fontSize: 16, color: CupertinoColors.systemRed),
              ),
            ),
          ],
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
                SizedBox(width: 4),
                Icon(CupertinoIcons.chevron_down),
              ],
            ),
          )
        ],
      ),
    );
  }
}


class FilterLineButton extends StatelessWidget {
  final UserCollectionClassification classification;
  final Function(UserCollectionClassification) onFilterResult;

  const FilterLineButton({
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
                    onFilterResult(
                      UserCollectionClassification(
                        genres: {item},
                        labels: <String>{},
                        artists: <String>{},
                      ),
                    );
                    Navigator.pop(context);
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
                    onFilterResult(
                      UserCollectionClassification(
                        genres: <String>{},
                        labels: {item},
                        artists: <String>{},
                      ),
                    );
                    Navigator.pop(context);
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
                    onFilterResult(
                      UserCollectionClassification(
                        genres: <String>{},
                        labels: <String>{},
                        artists: {item},
                      ),
                    );
                    Navigator.pop(context);
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
          actions: [
            ...buildGroupedActions(),
            CupertinoActionSheetAction(
              onPressed: () {
                // Clear Filter: 빈 UserCollectionClassification 전달
                onFilterResult(
                  UserCollectionClassification(
                    genres: <String>{},
                    labels: <String>{},
                    artists: <String>{},
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text(
                'Clear Filter',
                style: TextStyle(fontSize: 16, color: CupertinoColors.systemRed),
              ),
            ),
          ],
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
          IconButton(
            icon: const Icon(
              CupertinoIcons.line_horizontal_3,
              color: CupertinoColors.systemGrey,
              size: 20,
            ),
            onPressed: () => _openFilterSheet(context),
          )
        ],
      ),
    );
  }
}
