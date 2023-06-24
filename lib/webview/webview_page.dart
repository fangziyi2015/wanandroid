import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';

import '../util/toast.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;

  const WebViewPage(this.url, this.title, {super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  // Instance of WebView plugin
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  late StreamSubscription<double> _onProgressChanged;

  bool isLoadCompleted = false;

  @override
  void initState() {
    _onProgressChanged =
        flutterWebViewPlugin.onProgressChanged.listen((double progress) {
      if (mounted) {
        setState(() {
          if (progress == 1.0) {
            isLoadCompleted = true;
          }
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _onProgressChanged.cancel();
    flutterWebViewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("url = ${widget.url}");
    return MaterialApp(
      theme: ThemeData(primaryColor: Theme.of(context).primaryColor),
      routes: {
        "/": (_) => WebviewScaffold(
              url: widget.url,
              appBar: AppBar(
                title: Text(widget.title),
                bottom: const PreferredSize(
                  preferredSize: Size.fromHeight(1.0),
                  child: LinearProgressIndicator(),
                ),
                bottomOpacity: isLoadCompleted ? 0.0 : 1.0,
                leading: IconButton(
                  onPressed: () {
                    Navigator.maybePop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                actions: [
                  IconButton(
                      tooltip: "分享",
                      onPressed: () {
                        Share.share('【${widget.title}】\n${widget.url}');
                      },
                      icon: const Icon(Icons.share)),
                ],
              ),
              initialChild: const Center(
                child: CircularProgressIndicator(),
              ),
              withZoom: true,
              withLocalStorage: true,
              hidden: false,
            )
      },
    );
  }
}
