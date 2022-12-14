// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// import 'getdata.dart';
// import 'model/api_model.dart';
//
// class WebViewPage extends StatefulWidget {
//   const WebViewPage(String appUrl, {Key? key}) : super(key: key);
//   @override
//   State<WebViewPage> createState() => _WebViewPageState();
// }
//
// class _WebViewPageState extends State<WebViewPage> {
//   Future<DataModel?>? getDataModel;
//
//   @override
//   void initState() {
//     getDataModel = GetData.getInfoData();
//
//     super.initState();
//   }
//   // Message applink = Message(appId: appId, erpName: erpName, appName: appName, appLink: appLink, appUrl: appUrl, appStoreLink: appStoreLink, appVersionCode: appVersionCode, appVersionName: appVersionName, iosAppVersionCode: iosAppVersionCode, iosAppVersionName: iosAppVersionName, updatetime: updatetime)
//
//   final Completer<WebViewController> _controllerCompleter =
//       Completer<WebViewController>();
//   WebViewController? _controller;
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () => _goBack(context),
//       child: Scaffold(
//         body: FutureBuilder(
//           future: getDataModel,
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               return WebView(
//                 navigationDelegate: (NavigationRequest request) {
//                   if (request.url.startsWith("mailto:") ||
//                       request.url.startsWith("tel:") ||
//                       request.url.startsWith("whatsapp:")) {
//                     _launchURL(request.url);
//                     return NavigationDecision.prevent;
//                   } else {
//                     return NavigationDecision.navigate;
//                   }
//                 },
//                 onWebViewCreated: (WebViewController webViewController) {
//                   _controllerCompleter.future
//                       .then((value) => _controller = value);
//                   _controllerCompleter.complete(webViewController);
//                 },
//                 initialUrl: snapshot.data!.message[0].appLink,
//                 javascriptMode: JavascriptMode.unrestricted,
//               );
//             } else {
//               return Center(
//                   child: LoadingAnimationWidget.bouncingBall(
//                       color: Color(0xFF660505), size: 25));
//             }
//           },
//         ),
//       ),
//     );
//   }
//
//   Future<bool> _goBack(BuildContext context) async {
//     if (await _controller!.canGoBack()) {
//       _controller!.goBack();
//       return Future.value(false);
//     } else {
//       showDialog(
//         barrierDismissible: false,
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text(
//             "Are You Sure! You Want To Quit",
//             style: TextStyle(fontSize: 15),
//           ),
//           actions: <Widget>[
//             ElevatedButton(
//               style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text("Cancel"),
//             ),
//             ElevatedButton(
//               style: ButtonStyle(
//                   backgroundColor:
//                       MaterialStateProperty.all<Color>(Colors.red)),
//               onPressed: () {
//                 SystemNavigator.pop();
//               },
//               child: const Text("Yes"),
//             ),
//           ],
//         ),
//       );
//       return Future.value(true);
//     }
//   }
//
//   // Future<bool> _onWillPopCallback() {}
// }
//
// _launchURL(String url) async {
//   if (await canLaunch(url)) {
//     await launch(url);
//   } else {
//     throw 'Could not launch $url';
//   }
// }
