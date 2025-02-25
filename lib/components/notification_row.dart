import 'package:flutter/cupertino.dart';
import 'package:kolektt/view/notification.dart';

import '../model/notification_model.dart';

class NotificationRow extends StatelessWidget {
  final NotificationModel notification;

  NotificationRow({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          // 알림 아이콘
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: notification.type.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.heart_fill, // Icon can be dynamic based on type
                color: notification.type.color,
                size: 24,
              ),
            ),
          ),
          SizedBox(width: 16),
          // 알림 메시지 및 날짜
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.message,
                  style: TextStyle(
                    fontSize: 14,
                    color: notification.isRead
                        ? CupertinoColors.systemGrey
                        : CupertinoColors.black,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  formatDate(notification.date),
                  style: TextStyle(
                    fontSize: 12,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ],
            ),
          ),
          // 읽지 않은 알림 표시
          if (!notification.isRead)
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: CupertinoColors.activeBlue,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays > 0) {
      return "${difference.inDays}일 전";
    } else if (difference.inHours > 0) {
      return "${difference.inHours}시간 전";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes}분 전";
    } else {
      return "방금";
    }
  }
}
