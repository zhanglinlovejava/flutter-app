import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:async';
import 'package:flutter_open/utils/Tools.dart';
import '../utils/ActionViewUtils.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;

  WebViewPage({this.url = "https://www.baidu.com", this.title = 'title'});

  @override
  _WebViewPage createState() => _WebViewPage();
}

class _WebViewPage extends State<WebViewPage> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  @override
  void initState() {
    super.initState();
    _onStateChanged =
        flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
          print('WebViewStateChanged----->${state.url}');
    });
  }

  @override
  Widget build(BuildContext context) {
    double top = kToolbarHeight + Tools.getStatusHeight(context);
    flutterWebViewPlugin.launch(
      widget.url,
      rect: new Rect.fromLTWH(0.0, top, MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height - top),
    );
    return new Scaffold(
        appBar: ActionViewUtils.buildAppBar(title: widget.title));
  }

  @override
  void dispose() {
    _onStateChanged.cancel();
    flutterWebViewPlugin.close();
    flutterWebViewPlugin.dispose();
    super.dispose();
  }
}
