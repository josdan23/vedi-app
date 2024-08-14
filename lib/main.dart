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
  bool _showErrorPage = false;
  String _error = '';

  final _homePath = 'https://vedi.cordoba.gob.ar/VeDiPortal/home';
  final _controller = WebViewController();

  @override
  void initState() {
    super.initState();

    _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    _controller.setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          print('PROGRES: $progress');
        },
        onPageStarted: (String url) {
          print('STARTED: $url');

          if (url.contains('https://vedi.cordoba.gob.ar/')) {
            setState(() {
              _showHomeButton = false;
            });
          } else {
            setState(() {
              _showHomeButton = true;
            });
          }
        },
        onPageFinished: (String url) {
          print('FINISH: $url');
        },
        onHttpError: (HttpResponseError error) {
          print('HTTP_ERROR ${error.toString()}');
        },
        onWebResourceError: (WebResourceError error) {
          print('WEB_RESOURCE_ERROR: ${error.toString()}');
          setState(() {
            _showErrorPage = true;
            _error = error.description;
          });
        },
      ),
    );

    _controller.loadRequest(
        Uri.parse('https://vedi.cordoba.gob.ar/VeDiLandingPage'),
        headers: {'Permissions-Policy': 'ch-ua-form-factor'});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: _showErrorPage
            ? _ErrorPage(
                error: _error,
              )
            : SafeArea(
                child: WebViewWidget(
                  controller: _controller,
                ),
              ),
        bottomNavigationBar: _showHomeButton
            ? NavigationBar(
                destinations: [
                  const SizedBox(),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _showErrorPage = false;
                      });
                      _controller.loadRequest(Uri.parse(_homePath));
                    },
                    icon: const Icon(Icons.home),
                  ),
                  const SizedBox(),
                ],
              )
            : const SizedBox(),
      ),
    );
  }
}

class _ErrorPage extends StatelessWidget {
  final String error;
  const _ErrorPage({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "images/error.gif",
        ),
        const Text('Ups, tenemos un problema!'),
        Text(error),
      ],
    );
  }
}
