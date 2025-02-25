import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/notification_row.dart';
import '../model/notification_model.dart';

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
