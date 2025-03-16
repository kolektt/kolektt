import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kolektt/figma_colors.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../view_models/auth_vm.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('설정'),
        leading: CupertinoNavigationBarBackButton(
          onPressed: () {
            // Handle back button action
          },
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildListItem(
                    context,
                    icon: Icon(
                      CupertinoIcons.circle_grid_hex,
                      color: CupertinoColors.black,
                    ),
                    title: 'About Kolektt',
                  ),
                  _buildListItem(
                    context,
                    icon: Icon(
                      CupertinoIcons.question_circle,
                      color: CupertinoColors.black,
                    ),
                    title: 'Help Center',
                  ),
                  _buildListItem(
                    context,
                    icon: Icon(
                      CupertinoIcons.shield,
                      color: CupertinoColors.black,
                    ),
                    title: 'Privacy Policy',
                  ),
                  _buildListItem(
                    context,
                    icon: Icon(
                      CupertinoIcons.doc_text,
                      color: CupertinoColors.black,
                    ),
                    title: 'Terms of Service',
                  ),
                  _buildListItem(
                    context,
                    icon: Icon(
                      CupertinoIcons.info_circle,
                      color: CupertinoColors.black,
                    ),
                    title: 'App Version',
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 30.0),
              child: CupertinoButton(
                onPressed: () async {
                  final auth = context.read<AuthViewModel>();
                  await auth.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => KolekttApp(),
                      maintainState: false,
                    ), (route) => true,
                  );
                },
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: CupertinoColors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context,
      {required Icon icon, required String title}) {
    return Container(
      height: 64,
      child: CupertinoButton(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        onPressed: () {
          // Handle menu item tap
        },
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(right: 16.0),
              child: icon,
            ),
            Expanded(
              child: Text(
                title,
                style: FigmaTextStyles().bodymd.copyWith(color: FigmaColors.socialappleprimary),
              ),
            ),
            Icon(
              CupertinoIcons.chevron_right,
              color: CupertinoColors.systemGrey,
              size: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
