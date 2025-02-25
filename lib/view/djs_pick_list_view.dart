import 'package:flutter/cupertino.dart';

class DJsPickListView extends StatelessWidget {
  const DJsPickListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("DJ's List")),
      child: Center(child: Text("All DJ Picks")),
    );
  }
}
