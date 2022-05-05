import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:nibbles/view/home.dart';

const title = 'Nibbles';

void main() {
  runApp(const MyApp());

  if (kIsWeb) {
    return;
  } else if (Platform.isIOS || Platform.isAndroid) {
    return;
  } else {
    doWhenWindowReady(() {
      const initialSize = Size(500, 500);
      appWindow.minSize = const Size(300, 300);
      appWindow.size = initialSize;
      appWindow.alignment = Alignment.center;
      appWindow.show();
      appWindow.title = title;
    });
  }
}

const borderColor = Color(0xFF805306);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleBar = Container(
      color: Colors.red,
      child: Row(
        children: const [
          Expanded(
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // here
      navigatorObservers: [FlutterSmartDialog.observer],
      // here
      builder: FlutterSmartDialog.init(),
      home: Column(
        children: [
          if (kIsWeb)
            Container()
          else if (Platform.isAndroid || Platform.isIOS)
            Container(
              height: MediaQueryData.fromWindow(window).padding.top,
              //kToolbarHeight
              color: Colors.redAccent,
            )
          else
            WindowTitleBarBox(
              child: MoveWindow(
                child: titleBar,
              ),
            ),
          const Expanded(
            child: MyHomePage(),
          ),
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.top,
    ]);
    return Scaffold(
      body: Container(
        color: const Color(0xFFDB806E),
        child: const HomePage(),
      ),
    );
  }
}
