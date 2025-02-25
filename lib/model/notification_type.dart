import 'package:flutter/cupertino.dart';

enum NotificationType { like, follow, comment, sale }

extension NotificationTypeExtension on NotificationType {
  String get icon {
    switch (this) {
      case NotificationType.like:
        return CupertinoIcons.heart_fill.toString();
      case NotificationType.follow:
        return CupertinoIcons.person_add_solid.toString();
      case NotificationType.comment:
        return CupertinoIcons.bubble_right_fill.toString();
      case NotificationType.sale:
        return CupertinoIcons.tag_fill.toString();
    }
  }

  Color get color {
    switch (this) {
      case NotificationType.like:
        return CupertinoColors.systemRed;
      case NotificationType.follow:
        return CupertinoColors.systemBlue;
      case NotificationType.comment:
        return CupertinoColors.systemGreen;
      case NotificationType.sale:
        return CupertinoColors.systemOrange;
    }
  }
}
