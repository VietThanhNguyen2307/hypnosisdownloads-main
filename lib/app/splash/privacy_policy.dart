import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  static MaterialPageRoute<dynamic> get route =>
      MaterialPageRoute(builder: (context) => const PrivacyPolicyPage());

  static String url = 'https://www.hypnosisdownloads.com/help-center/privacy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
            SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
            ));
          },
        ),
      ),
      body: WebViewWidget(
        controller: WebViewController()
          ..loadRequest(
            Uri.parse(url),
          ),
      ),
    );
  }
}
