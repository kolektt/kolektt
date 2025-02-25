import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'other_user_profile_view.dart';

class FollowingListView extends StatelessWidget {
  const FollowingListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("팔로잉")),
      child: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 20,
          itemBuilder: (_, index) {
            return CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) => OtherUserProfileView()),
                );
              },
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor:
                    CupertinoColors.systemGrey.withOpacity(0.2),
                    child: Icon(CupertinoIcons.person,
                        color: CupertinoColors.systemGrey),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("DJ Name", style: TextStyle(fontSize: 16)),
                      Text("House / Techno",
                          style: TextStyle(
                              fontSize: 12, color: CupertinoColors.systemGrey)),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
