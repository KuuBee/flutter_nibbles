import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

void main() {
  runApp(const MyApp());

  doWhenWindowReady(() {
    const initialSize = Size(600, 450);
    appWindow.minSize = const Size(100, 100);
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

const borderColor = Color(0xFF805306);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Column(
        children: [
          WindowTitleBarBox(
            child: Container(
              color: Colors.red,
              child: MoveWindow(),
            ),
          ),
          const Expanded(
            child: MyHomePage(title: 'Flutter Demo Home Page'),
          ),
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final width = appWindow.size.width;
    final height = appWindow.size.height;
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return Container(
          color: Colors.purpleAccent.withOpacity(.2),
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Container(
              color: Colors.green.withOpacity(.5),
              height: height,
              width: width,
              child: Column(
                children: List.generate(
                  10,
                  (index) => Row(
                    children: List.generate(
                      10,
                      (index) => Container(
                        width: width / 10,
                        height: height / 10,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
