import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool _showHomeButton = false;
  final _homePath = 'https://vedi.cordoba.gob.ar/VeDiPortal/home';

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {
            if (!url.contains('https://vedi.cordoba.gob.ar/VeDiPortal/')) {
              setState(() {
                _showHomeButton = true;
              });
            } else {
              setState(() {
                _showHomeButton = false;
              });
            }
          },
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse('https://vedi.cordoba.gob.ar/VeDiLandingPage'));

    return MaterialApp(
      home: Scaffold(
        body: Expanded(
          child: WebViewWidget(
            controller: controller,
          ),
        ),
        bottomNavigationBar: NavigationBar(
          destinations: [
            const SizedBox(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.home),
            ),
            const SizedBox(),
          ],
        ),
      ),
    );
  }
}
