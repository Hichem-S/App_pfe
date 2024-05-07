import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatefulWidget {
  const WebViewContainer({super.key});

  @override
  State<WebViewContainer> createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {
  WebViewController controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setBackgroundColor(const Color(0x00000000))
  ..loadRequest(Uri.parse('http://192.168.119.162:5000/'));
  @override
  Widget build(BuildContext context) {
     return Scaffold(
    appBar: AppBar(title: const Text('Camera Stream')),
    body: WebViewWidget(controller: controller),
  );
  }
}