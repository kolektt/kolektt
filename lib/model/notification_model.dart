import 'package:flutter/cupertino.dart';

import '../view/notification.dart';

class NotificationModel {
  final Key id;
  final NotificationType type;
  final String message;
  final DateTime date;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.type,
    required this.message,
    required this.date,
    required this.isRead,
  });
}
