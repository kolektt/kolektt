import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationsView extends StatelessWidget {
  // 임시 알림 데이터
  final List<NotificationModel> notifications = [
    NotificationModel(
      id: UniqueKey(),
      type: NotificationType.like,
      message: "DJ Huey님이 회원님의 컬렉션을 좋아합니다",
      date: DateTime.now().subtract(Duration(hours: 1)),
      isRead: false,
    ),
    NotificationModel(
      id: UniqueKey(),
      type: NotificationType.follow,
      message: "DJ Smith님이 회원님을 팔로우하기 시작했습니다",
      date: DateTime.now().subtract(Duration(hours: 2)),
      isRead: false,
    ),
    NotificationModel(
      id: UniqueKey(),
      type: NotificationType.comment,
      message: "DJ Jane님이 회원님의 레코드에 댓글을 남겼습니다",
      date: DateTime.now().subtract(Duration(days: 1)),
      isRead: true,
    ),
    NotificationModel(
      id: UniqueKey(),
      type: NotificationType.sale,
      message: "관심 레코드의 새로운 매물이 등록되었습니다",
      date: DateTime.now().subtract(Duration(days: 2)),
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("알림"),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text("취소"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      child: SafeArea(
        child: CupertinoScrollbar(
          child: ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return NotificationRow(notification: notifications[index]);
            },
          ),
        ),
      ),
    );
  }
}

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

// 알림 행 컴포넌트
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