import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/statistic_card.dart';
import '../figma_colors.dart';
import '../model/collection_analytics.dart';

class CollectionSummaryView extends StatelessWidget {
  final CollectionAnalytics analytics;
  const CollectionSummaryView({Key? key, required this.analytics}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Theme colors
    final Color primaryColor = Colors.blue;
    final Color cardBackgroundColor = Colors.white;

    if (analytics.totalRecords == 0) {
      return Center(
        child: Text(
          "아직 레코드가 없습니다",
          style: const TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Records - Full width card
            StatisticCard(
              title: "Total Records",
              value: analytics.totalRecords.toString(),
              backgroundColor: primaryColor,
              textColor: Colors.white,
              height: 80,
              showAnalyzedBy: true,
              analyzedBy: "Kolektt",
            ),

            const SizedBox(height: 24),

            // Most Genre Section
            Text(
              "Most Genre",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 12),

            // Genre Card - Specialized card with pie chart would be implemented separately
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: cardBackgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    analytics.mostCollectedGenre.isEmpty ? "None" : analytics.mostCollectedGenre,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "36% 210 records",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),

                  // Additional genres would be listed here
                  const SizedBox(height: 8),
                  buildGenreRow("Acid", "25%", "100 Records"),
                  buildGenreRow("Disco", "18%", "60 Records"),
                  buildGenreRow("Techno", "10%", "50 Records"),
                  buildGenreRow("etc.", "5%", "30 Records"),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Favorite Artists Section
            Text(
              "Favorite Artists",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 12),

            // Simplified artist list (in production, this would be a separate component)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: cardBackgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  buildArtistRow("1", "BT", "12 Albums", true),
                  const SizedBox(height: 16),
                  buildArtistRow("2", "BLACKPINK", "14 Albums", false),
                  const SizedBox(height: 16),
                  buildArtistRow("3", "TWICE", "28 Albums", false),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Collection Period Section
            Text(
              "Collection Period",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: cardBackgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "My favorite\nera",
                        style: FigmaTextStyles().headingheading3.copyWith(color: FigmaColors.grey100),
                      ),
                      Text(
                        analytics.oldestRecord == 0
                            ? "None"
                            : "${analytics.oldestRecord}~${analytics.newestRecord}",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // Here would be a bar chart showing collection distribution by year
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget buildGenreRow(String genre, String percentage, String recordCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            genre,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              Text(
                percentage,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 16),
              Text(
                recordCount,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildArtistRow(String rank, String name, String albumCount, bool isUp) {
    return Row(
      children: [
        Text(
          rank,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 8),
        isUp ? Icon(Icons.arrow_upward, color: Colors.blue, size: 16)
            : Icon(Icons.remove, color: Colors.grey, size: 16),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              albumCount,
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
