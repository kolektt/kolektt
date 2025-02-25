import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

final List<String> genres = ["전체", "House", "Techno", "Disco", "Jazz", "Hip-Hop"];

enum SortOption { latest, popularity, priceLow, priceHigh }

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  String searchText = '';
  String selectedGenre = '전체';
  SortOption sortOption = SortOption.latest;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("검색"),
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
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: CupertinoTextField(
                padding: EdgeInsets.symmetric(horizontal: 16),
                placeholder: '레코드 검색',
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(10),
                ),
                prefix: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(CupertinoIcons.search, color: CupertinoColors.inactiveGray),
                ),
              ),
            ),

            // Genre Filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CupertinoScrollbar(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: genres.map((genre) {
                      return CupertinoButton(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        color: selectedGenre == genre ? primaryColor : CupertinoColors.systemGrey5,
                        borderRadius: BorderRadius.circular(20),
                        onPressed: () {
                          setState(() {
                            selectedGenre = genre;
                          });
                        },
                        child: Text(
                          genre,
                          style: TextStyle(
                            color: selectedGenre == genre ? CupertinoColors.white : CupertinoColors.black,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            // Sort Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Spacer(),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      final SortOption? option = await showCupertinoModalPopup<SortOption>(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoActionSheet(
                            title: Text("정렬 옵션"),
                            actions: [
                              for (SortOption option in SortOption.values)
                                CupertinoActionSheetAction(
                                  onPressed: () {
                                    Navigator.pop(context, option);
                                  },
                                  child: Text(option.toString().split('.').last),
                                ),
                            ],
                          );
                        },
                      );
                      if (option != null) {
                        setState(() {
                          sortOption = option;
                        });
                      }
                    },
                    child: Row(
                      children: [
                        Text(
                          sortOption.toString().split('.').last,
                          style: TextStyle(fontSize: 14),
                        ),
                        Icon(CupertinoIcons.chevron_down),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Search Results or Suggestions
            if (searchText.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: 10, // Replace with actual data length
                  itemBuilder: (context, index) {
                    return CupertinoListTile(
                      leading: CircleAvatar(child: Icon(CupertinoIcons.music_note)),
                      title: Text('Record Title $index'),
                      subtitle: Text('Artist $index'),
                      onTap: () {
                        // Navigate to record details page
                      },
                    );
                  },
                ),
              )
            else
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text("최근 검색어", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (String term in ["Bicep", "Burial", "Four Tet", "Jamie xx"])
                                  CupertinoButton(
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    color: CupertinoColors.systemGrey5,
                                    borderRadius: BorderRadius.circular(16),
                                    onPressed: () {
                                      setState(() {
                                        searchText = term;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Text(term),
                                        Icon(CupertinoIcons.clear, size: 16),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text("추천 검색어", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (String term in ["Aphex Twin", "Boards of Canada", "Autechre", "Squarepusher"])
                                  CupertinoButton(
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    color: CupertinoColors.systemGrey5,
                                    borderRadius: BorderRadius.circular(16),
                                    onPressed: () {
                                      setState(() {
                                        searchText = term;
                                      });
                                    },
                                    child: Text(term),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
