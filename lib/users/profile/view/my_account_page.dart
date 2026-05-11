import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyAccountPage extends StatelessWidget {
  const MyAccountPage({Key? key}) : super(key: key);

  final String url = 'https://www.hypnosisdownloads.com/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebViewWidget(
        controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(
            Uri.parse(url),
          ),
      ),
    );
  }
}
