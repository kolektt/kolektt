import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/leader_board_user.dart';
import '../view/user_profile_vew.dart';

class LeaderboardCard extends StatelessWidget {
  final LeaderboardUser user;

  const LeaderboardCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.only(bottom: 16),
      onPressed: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (_) => UserProfileView(user: user),
          ),
        );
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 순위 뱃지
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.withOpacity(0.1),
              ),
              child: Center(
                child: Text(
                  "${user.rank}",
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // 프로필 이미지
            if (user.profileImageURL != null)
              ClipOval(
                child: Image.network(
                  user.profileImageURL!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.withOpacity(0.2),
                ),
                child: const Icon(
                  CupertinoIcons.person_fill,
                  color: Colors.grey,
                ),
              ),
            const SizedBox(height: 12),
            // 사용자 정보
            Column(
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "${formatAmount(user.amount)}원",
                  style: const TextStyle(
                      fontSize: 12, color: CupertinoColors.systemGrey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String formatAmount(int amount) {
    // 필요 시 intl 패키지의 NumberFormat 사용 고려
    return amount.toString();
  }
}
