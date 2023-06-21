import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';



class WebViewScreen extends StatelessWidget {

  final String url;
  const WebViewScreen({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.sociallone.com/')) {
              Uri uri=Uri.parse(request.url);
              String? code=uri.queryParameters['code'];
              String? state=uri.queryParameters['state'];
              print(request.url);
              print(code);
              print(state);
              Fluttertoast.showToast(msg: 'Authorization code- $code',
                  toastLength: Toast.LENGTH_LONG);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    return WebViewWidget(controller: controller);
  }
}



void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  final String loginUrl='https://www.facebook.com/v16.0/dialog/oauth?client_id=731880461729854&redirect_uri=https://www.sociallone.com/&state=abc&config_id=942560533731978';
  const MyApp({super.key});

  void _launchUrl(BuildContext context) async {
    try {
      if (await canLaunchUrl(Uri.parse(loginUrl))) {
        navigatePage(context);
      } else {
        Fluttertoast.showToast(msg: 'Could not launch the URL');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error launching the URL');
      print(e.toString());
    }
  }


  void navigatePage(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context)=>WebViewScreen(url:loginUrl)
      ),
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     return MaterialApp(
      title: 'Facebook login webview',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Facebook login webview'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () => _launchUrl(context),
            child: const Text('Login with Facebook'),
          ),
        ),
      ),
    );
  }




}

