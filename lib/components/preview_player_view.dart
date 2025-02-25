import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PreviewPlayerView extends StatefulWidget {
  final String url;

  PreviewPlayerView({required this.url});

  @override
  State<PreviewPlayerView> createState() => _PreviewPlayerViewState();
}

class _PreviewPlayerViewState extends State<PreviewPlayerView> {
  final WebViewController controller = WebViewController();

  @override
  void initState() {
    super.initState();
    controller.loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('미리듣기'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text('편집'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      child: SafeArea(
        child: WebViewWidget(
          controller: controller,
        ),
      ),
    );
  }
}
