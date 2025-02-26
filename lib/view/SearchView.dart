import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../view_models/search_vm.dart';

class SearchView extends StatelessWidget {
  const SearchView({Key? key}) : super(key: key);

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
                    onChanged: (value) {
                      model.updateSearchText(value);
                    },
                    onSubmitted: (_) {
                      model.search();
                    },
                  ),
                ),

                // 장르 필터
                SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: genres.length,
                      itemBuilder: (context, index) {
                        final genre = genres[index];
                        final isSelected = model.selectedGenre == genre;

                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: CupertinoButton(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            color: isSelected
                                ? CupertinoColors.activeBlue
                                : CupertinoColors.systemGrey5,
                            borderRadius: BorderRadius.circular(20),
                            onPressed: () {
                              model.updateSelectedGenre(genre);
                            },
                            child: Text(
                              genre,
                              style: TextStyle(
                                color: isSelected
                                    ? CupertinoColors.white
                                    : CupertinoColors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // 정렬 옵션 선택
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => _showSortOptions(context, model),
                        child: Row(
                          children: [
                            Text(
                              model.getSortOptionDisplayName(),
                              style: TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: 4),
                            Icon(CupertinoIcons.chevron_down),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // 검색 결과 또는 최근/추천 검색어 표시
                Expanded(
                  child: _buildContent(context, model),
                ),
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
              onPressed: () => model.search(),
              child: Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    if (model.results.isNotEmpty) {
      return _buildResultsList(model);
    }

    return _buildSuggestionsView(context, model);
  }

  Widget _buildResultsList(SearchViewModel model) {
    return ListView.builder(
      itemCount: model.results.length,
      itemBuilder: (context, index) {
        final record = model.results[index];
        return CupertinoListTile(
          leading: record.thumb.isNotEmpty
              ? ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage, // 투명한 1px GIF를 플레이스홀더로 사용
              image: record.thumb,
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
          subtitle: record.artists.isNotEmpty && record.artists[0].name != null
              ? Text(record.artists[0].name)
              : null,
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
    required List<String> terms,
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
                onPressed: () {
                  model.updateSearchText(term);
                  model.search();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(term),
                    if (showClearButton)
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: GestureDetector(
                          onTap: () {
                            model.removeSearchTerm(term);
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
