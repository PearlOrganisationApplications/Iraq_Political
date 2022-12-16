import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'getdata.dart';
import 'home_page.dart';
import 'model/api_model.dart';

enum NetworkStatus { online, offline }

Future<void> main() async {
  var connectedornot = NetworkStatus.offline;

  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      connectedornot = NetworkStatus.online;
    } else {
      connectedornot = NetworkStatus.offline;
    }
  } on SocketException catch (_) {
    connectedornot = NetworkStatus.offline;
  }
  runApp(MyApp(connectedornot: connectedornot));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.connectedornot}) : super(key: key);
  final connectedornot;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.black, statusBarBrightness: Brightness.dark));
    return GetMaterialApp(
        // color: Colors.white,
        debugShowCheckedModeBanner: false,
        title: "Iraq Political",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(
          title: "Iraq Political",
          connectedornot: connectedornot,
        )
        //     AnimatedSplashScreen(
        //   backgroundColor: Colors.white,
        //   duration: 5000,
        //   splashIconSize: 180,
        //   splash: "assets/logo.png",
        //   splashTransition: SplashTransition.fadeTransition,
        //   nextScreen: HomePage(
        //     connectedornot: connectedornot,
        //     title: "OSeki Masaai",
        //   ),
        // ),
        );
  }
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  final Completer<WebViewController> _controllerCompleter =
      Completer<WebViewController>();
  WebViewController? _controller;

  late Future<DataModel?> getDataModel;

  var iosVersion = "3";
  var androidVersion = "1";
  bool skipupdate = false;
  @override
  void initState() {
    getDataModel = GetData.getInfoData();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _goBack(context),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: FutureBuilder<DataModel?>(
          future: getDataModel,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (int.parse(snapshot.data!.message[0].iosAppVersionCode) >
                  int.parse(iosVersion)) {
                if (skipupdate) {}
              }
              return SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                      child: WebView(
                    navigationDelegate: (NavigationRequest request) {
                      if (request.url.startsWith("mailto:") ||
                          request.url.startsWith("tel:") ||
                          request.url.startsWith("whatsapp:")) {
                        _launchURL(request.url);
                        return NavigationDecision.prevent;
                      } else {
                        return NavigationDecision.navigate;
                      }
                    },
                    onWebViewCreated: (WebViewController webViewController) {
                      _controllerCompleter.future
                          .then((value) => _controller = value);
                      _controllerCompleter.complete(webViewController);
                    },
                    initialUrl:   snapshot.data!.message[0].appLink,
                    // "https://iraqipoliticalaffair.com",

                    javascriptMode: JavascriptMode.unrestricted,
                  )
                      // WebViewPage(
                      //   snapshot.data!.message[0].appLink,
                      // ),
                      ),
                ),
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Center(
                      child: LoadingAnimationWidget.bouncingBall(
                        color: const Color(0xFF660505),
                        size: 80,
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> _goBack(BuildContext context) async {
    if (await _controller!.canGoBack()) {
      _controller!.goBack();
      return Future.value(false);
    } else {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            "Are You Sure! You Want To Quit",
            style: TextStyle(fontSize: 15),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.red)),
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text("Yes"),
            ),
          ],
        ),
      );
      return Future.value(true);
    }
  }

// Future<bool> _onWillPopCallback() {}
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
