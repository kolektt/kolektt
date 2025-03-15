import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatisticCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color backgroundColor;
  final Color textColor;
  final double width;
  final double height;
  final EdgeInsets padding;
  final bool showAnalyzedBy;
  final String analyzedBy;
  final IconData? icon;

  const StatisticCard({
    Key? key,
    required this.title,
    required this.value,
    this.subtitle = '',
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.width = double.infinity,
    this.height = 100,
    this.padding = const EdgeInsets.all(16),
    this.showAnalyzedBy = false,
    this.analyzedBy = '',
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: 16, color: textColor),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  if (showAnalyzedBy && analyzedBy.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Analyzed by $analyzedBy',
                        style: TextStyle(
                          fontSize: 12,
                          color: textColor.withOpacity(0.7),
                        ),
                      ),
                    ),
                ],
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          if (subtitle.isNotEmpty)
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: textColor.withOpacity(0.8),
              ),
            ),
        ],
      ),
    );
  }
}
