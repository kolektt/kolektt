import 'package:flutter/cupertino.dart';

import '../model/leader_board_user.dart';

class UserProfileView extends StatelessWidget {
  final LeaderboardUser user;

  const UserProfileView({required this.user});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(user.name)),
      child: Center(child: Text("User Profile View")),
    );
  }
}
