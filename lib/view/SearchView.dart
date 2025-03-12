import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../domain/entities/search_term.dart';
import '../view_models/search_vm.dart';

class SearchView extends StatefulWidget {
  final String? initialSearchTerm;
  const SearchView({Key? key, this.initialSearchTerm}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  bool _isSearchTriggered = false;

  @override
  void initState() {
    super.initState();
    // 첫 프레임이 완료된 후에 자동 검색 실행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isSearchTriggered && widget.initialSearchTerm?.isNotEmpty == true) {
        final model = Provider.of<SearchViewModel>(context, listen: false);
        // 검색 필드에 초기 검색어 설정
        model.searchController.text = widget.initialSearchTerm!;
        // 검색어 업데이트 후 검색 실행
        model.updateSearchText(widget.initialSearchTerm!).then((_) {
          model.search();
        });
        _isSearchTriggered = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchViewModel>(
      builder: (context, model, child) {
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text('검색'),
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              child: Text("취소"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // 검색 입력 필드
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: CupertinoSearchTextField(
                    controller: model.searchController,
                    placeholder: '레코드 검색',
                    onChanged: (value) async {
                      await model.updateSearchText(value);
                    },
                    onSubmitted: (_) async {
                      await model.search();
                    },
                  ),
                ),
                // (기존 나머지 SearchView 내용 유지)
                // 예: 장르 필터, 정렬 옵션, 검색 결과/추천 검색어 표시 등...
                Expanded(child: _buildContent(context, model)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, SearchViewModel model) {
    if (model.isLoading) {
      return Center(child: CupertinoActivityIndicator());
    }
    if (model.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.exclamationmark_circle, size: 48, color: CupertinoColors.systemRed),
            const SizedBox(height: 16),
            Text('Error: ${model.errorMessage}', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            CupertinoButton(
              onPressed: () async => await model.search(),
              child: Text('다시 시도'),
            ),
          ],
        ),
      );
    }
    if (model.results.isNotEmpty) {
      return _buildResultsList(model);
    }
    // 검색어가 입력된 상태에서 결과가 없을 경우 빈 상태 UI 표시
    if (model.searchController.text.isNotEmpty) {
      return _buildEmptyResults(context, model);
    }
    // 검색어가 없는 경우 추천 검색어 등 보여주기
    return _buildSuggestionsView(context, model);
  }

  Widget _buildEmptyResults(BuildContext context, SearchViewModel model) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.search, size: 64, color: CupertinoColors.systemGrey),
            const SizedBox(height: 16),
            Text(
              '검색 결과가 없습니다.',
              style: TextStyle(fontSize: 18, color: CupertinoColors.systemGrey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            CupertinoButton(
              onPressed: () {
                // 예: 검색어 초기화 처리 (SearchViewModel에 clearSearch() 메서드를 구현해야 합니다.)
                model.clearSearch();
              },
              child: Text('검색어 초기화'),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildResultsList(SearchViewModel model) {
    return ListView.builder(
      itemCount: model.results.length,
      itemBuilder: (context, index) {
        final record = model.results[index];
        return CupertinoListTile(
          leading: record.coverImage.isNotEmpty
              ? ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage, // 투명한 1px GIF를 플레이스홀더로 사용
              image: record.coverImage,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              fadeInDuration: const Duration(milliseconds: 300), // 페이드 효과 지속 시간
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
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey5,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(CupertinoIcons.music_note)),
          title: Text(record.title),
          // artists 리스트가 비어있지 않은 경우에만 첫번째 artist의 이름을 표시
          subtitle: null,
          trailing:
          Icon(CupertinoIcons.chevron_right, color: CupertinoColors.systemGrey),
          onTap: () {
            model.onRecordSelected(record, context);
          },
        );
      },
    );
  }

  Widget _buildSuggestionsView(BuildContext context, SearchViewModel model) {
    return ListView(
      children: [
        // 최근 검색어 표시
        if (model.recentSearchTerms.isNotEmpty)
          _buildSearchTermsSection(
            title: "최근 검색어",
            terms: model.recentSearchTerms,
            model: model,
            showClearButton: true,
          ),

        // 추천 검색어 표시
        _buildSearchTermsSection(
          title: "추천 검색어",
          terms: model.suggestedSearchTerms,
          model: model,
          showClearButton: false,
        ),
      ],
    );
  }

  Widget _buildSearchTermsSection({
    required String title,
    required List<SearchTerm> terms,
    required SearchViewModel model,
    required bool showClearButton,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              if (showClearButton && terms.isNotEmpty)
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Text("모두 지우기"),
                  onPressed: () => model.clearRecentSearches(),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: terms.map((term) {
              return CupertinoButton(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: CupertinoColors.systemGrey5,
                borderRadius: BorderRadius.circular(16),
                onPressed: () async {
                  await model.updateSearchText(term.term);
                  await model.search();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(term.term),
                    if (showClearButton)
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: GestureDetector(
                          onTap: () {
                            model.removeSearchTerm(term.term);
                            },
                          child: Icon(CupertinoIcons.clear_circled, size: 16),
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Future<void> _showSortOptions(BuildContext context, SearchViewModel model) async {
    final selectedOption = await showCupertinoModalPopup<SortOption>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text("정렬 옵션"),
          actions: SortOption.values.map((option) =>
              CupertinoActionSheetAction(
                isDefaultAction: model.sortOption == option,
                onPressed: () {
                  Navigator.pop(context, option);
                },
                child: Text(model.getSortOptionDisplayName(option)),
              )
          ).toList(),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("취소"),
          ),
        );
      },
    );

    if (selectedOption != null) {
      model.updateSortOption(selectedOption);
    }
  }
}
