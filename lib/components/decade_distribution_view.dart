import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';

import '../model/decade_analytics.dart';

class DecadeDistributionView extends StatelessWidget {
  final List<DecadeAnalytics> decades;
  const DecadeDistributionView({Key? key, required this.decades}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color primaryColor = const Color(0xFF0036FF);
    if (decades.isEmpty) {
      return Center(
        child: Text(
          "아직 연도 데이터가 없습니다",
          style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
        ),
      );
    }
    List<DecadeAnalytics> sortedDecades = List.from(decades)
      ..sort((a, b) => a.decade.compareTo(b.decade));
    double maxY = sortedDecades.map((e) => e.count).reduce((a, b) => a > b ? a : b).toDouble() + 2;
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
                final decade = sortedDecades[group.x.toInt()];
                return BarTooltipItem(
                  "${decade.count}장",
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
                  if (index < sortedDecades.length) {
                    String label = sortedDecades[index].decade;
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
          barGroups: sortedDecades.asMap().entries.map((entry) {
            int index = entry.key;
            final decade = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: decade.count.toDouble(),
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
