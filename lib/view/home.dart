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
    columnCount: 17,
    rowCount: 15,
    timeInterval: const Duration(milliseconds: 170),
    obstacle: [],
  );
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: FittedBox(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              color: const Color(0xFFC94A3E),
              width: config.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Expanded(
                    child: Text(
                      'score:10',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            RepaintBoundary(
              child: NibblesWidget(
                config: config,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
