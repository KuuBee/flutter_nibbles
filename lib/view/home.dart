import 'package:flutter/material.dart';
import 'package:nibbles/core/game_config.dart';
import 'package:nibbles/widget/map.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final config = GameConfig(
    columnCount: 3,
    rowCount: 3,
    timeInterval: const Duration(milliseconds: 500),
    obstacle: [],
  );
  final scoreVal = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
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
      ),
    );
  }
}
