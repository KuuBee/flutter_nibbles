import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:nibbles/core/game_config.dart';
import 'package:nibbles/widget/map.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final config = GameConfig(
    columnCount: 15,
    rowCount: 17,
    timeInterval: const Duration(milliseconds: 200),
    obstacle: [],
  );
  final scoreVal = ValueNotifier(0);

  double get titleBarHeight {
    if (kIsWeb) {
      return 30.0;
    } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return appWindow.titleBarHeight;
    } else {
      return 30.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          color: const Color(0xFFC94A3E),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: scoreVal,
                  builder: (context, value, child) {
                    return Text(
                      'score:$value',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    );
                  },
                ),
              ),
              InkWell(
                onTap: () async {
                  try {
                    final url =
                        Uri.parse('https://github.com/KuuBee/flutter_nibbles');
                    await launchUrl(url);
                  } catch (error) {
                    SmartDialog.showToast('跳转失败了');
                  }
                },
                child: Image.asset(
                  'images/github_logo.png',
                  height: titleBarHeight,
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: FittedBox(
            child: NibblesWidget(
              config: config,
              onScoreChange: (score) {
                scoreVal.value = score;
              },
            ),
          ),
        ),
      ],
    );
  }
}
