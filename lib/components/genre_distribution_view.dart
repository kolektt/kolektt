import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kolektt/figma_colors.dart';

import '../model/genre_analytics.dart';

class GenreDistributionView extends StatelessWidget {
  final List<GenreAnalytics> genres;
  const GenreDistributionView({Key? key, required this.genres}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    Color primaryColor = const Color(0xFF0036FF);
    
    if (genres.isEmpty) {
      return Center(
        child: Text(
          "아직 장르 데이터가 없습니다",
          style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
        ),
      );
    }
    
    List<GenreAnalytics> sortedGenres = List.from(genres)
      ..sort((a, b) => b.count.compareTo(a.count));
    
    // Calculate total records
    int totalRecords = sortedGenres.fold(0, (sum, genre) => sum + genre.count);
    
    // Take top 4 genres and combine the rest as "etc."
    List<GenreAnalytics> displayGenres = [];
    if (sortedGenres.length > 4) {
      displayGenres = sortedGenres.take(3).toList();
      int otherCount = sortedGenres.skip(3).fold(0, (sum, genre) => sum + genre.count);
      displayGenres.add(GenreAnalytics(name: "etc.", count: otherCount));
    } else {
      displayGenres = sortedGenres;
    }
    
    // Generate colors for pie chart sections
    List<Color> sectionColors = [
      primaryColor,
      const Color(0xFFAAAAAA),
      const Color(0xFFCCCCCC),
      const Color(0xFFDDDDDD),
    ];
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 0,
                centerSpaceRadius: 40,
                sections: displayGenres.asMap().entries.map((entry) {
                  int index = entry.key;
                  GenreAnalytics genre = entry.value;
                  double percentage = (genre.count / totalRecords) * 100;
                  
                  return PieChartSectionData(
                    color: index < sectionColors.length ? sectionColors[index] : Colors.grey,
                    value: genre.count.toDouble(),
                    title: '',
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            displayGenres.first.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "${(displayGenres.first.count / totalRecords * 100).toInt()}% ${displayGenres.first.count} records",
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          Column(
            children: displayGenres.map((genre) {
              double percentage = (genre.count / totalRecords) * 100;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      genre.name,
                      style: FigmaTextStyles().headingheading4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Text(
                          "${percentage.toInt()}%",
                          style: FigmaTextStyles().bodysm,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          "${genre.count} Records",
                          style: FigmaTextStyles().bodysm,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
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
}
