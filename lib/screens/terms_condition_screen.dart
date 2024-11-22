import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

const headingRedColor = Color(0xFFec2227);
const darkGrey = Color.fromARGB(255, 119, 109, 109);

class TermsConditionScreen extends StatefulWidget {
  const TermsConditionScreen({super.key});

  @override
  State<TermsConditionScreen> createState() => _TermsConditionScreenState();
}

class _TermsConditionScreenState extends State<TermsConditionScreen> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            // Inject JavaScript after the page finishes loading
            _controller.runJavaScript(
              '''
              document.getElementsByTagName("footer")[0]?.style.setProperty("display", "none", "important");
              document.getElementsByClassName("copyright")[0]?.style.setProperty("display", "none", "important");
              document.getElementsByClassName("fixed")[0]?.style.setProperty("display", "none", "important");
            ''',
            );
          },
        ),
      )
      ..loadRequest(Uri.parse('https://islandcare.bm/terms-and-conditions'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("Terms and Conditions"),
      ),
      body: WebViewWidget(
        controller: _controller,
      ),
    );
  }
}
