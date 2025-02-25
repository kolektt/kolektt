import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';

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
    List<GenreAnalytics> topGenres = sortedGenres.take(6).toList();
    double maxY = topGenres.map((e) => e.count).reduce((a, b) => a > b ? a : b).toDouble() + 2;
    return Container(
      height: 200,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final genre = topGenres[group.x.toInt()];
                return BarTooltipItem(
                  "${genre.count}장",
                  TextStyle(color: CupertinoColors.white, fontSize: 12),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (double value, TitleMeta meta) {
                  int index = value.toInt();
                  if (index < topGenres.length) {
                    String label = topGenres[index].name == "기타" ? "미분류" : topGenres[index].name;
                    return SideTitleWidget(
                      space: 4,
                      meta: meta,
                      child: Text(
                        label,
                        style: TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: 1,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
          barGroups: topGenres.asMap().entries.map((entry) {
            int index = entry.key;
            final genre = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: genre.count.toDouble(),
                  width: 20,
                  borderRadius: BorderRadius.circular(4),
                  color: primaryColor,
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
