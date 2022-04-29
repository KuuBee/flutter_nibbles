import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nibbles/core/game_config.dart';
import 'package:nibbles/core/nibbles_core.dart';
import 'package:nibbles/core/nibbles_linked_list.dart';

class NibblesWidget extends StatefulWidget {
  const NibblesWidget({Key? key}) : super(key: key);

  @override
  State<NibblesWidget> createState() => _NibblesWidgetState();
}

class _NibblesWidgetState extends State<NibblesWidget> {
  final config = GameConfig(
      columnCount: 10,
      rowCount: 10,
      timeInterval: const Duration(milliseconds: 500),
      obstacle: [
        10,
        11,
        12,
        13,
        14,
      ]);
  late final FocusNode node;
  late final NibblesCore core = NibblesCore(nibblesHeader, config);
  late final NibblesLinkedList nibblesHeader = NibblesLinkedList(
    0,
    Direction.right,
  );
  Direction currentDirection = Direction.right;

  @override
  initState() {
    node = FocusNode(
      debugLabel: 'move',
      onKey: onKey,
    );
    core.generatePointNode();
    init();
    super.initState();
  }

  init() {
    Timer.periodic(config.timeInterval, (timer) {
      try {
        setState(() {
          final returnDir = core.moveDirection(currentDirection);
          if (returnDir != null) currentDirection = returnDir;
        });
      } catch (error) {
        log(error.toString());
        timer.cancel();
      }
    });
  }

  KeyEventResult onKey(FocusNode node, RawKeyEvent event) {
    switch (event.logicalKey.keyId) {
      // right
      case 0x00100000303:
        {
          currentDirection = Direction.right;
          break;
        }
      // left
      case 0x00100000302:
        {
          currentDirection = Direction.left;
          break;
        }
      // down
      case 0x00100000301:
        {
          currentDirection = Direction.down;
          break;
        }
      // up
      case 0x00100000304:
        {
          currentDirection = Direction.up;
          break;
        }
      default:
        {
          return KeyEventResult.ignored;
        }
    }
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = config.itemCount;
    return KeyboardListener(
      focusNode: node,
      child: FittedBox(
        fit: BoxFit.contain,
        child: RepaintBoundary(
          child: Container(
            color: Colors.green.withOpacity(.5),
            height: config.height,
            width: config.width,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: config.columnCount,
                childAspectRatio: 1.0,
              ),
              itemCount: itemCount,
              itemBuilder: (context, index) {
                bool isEnd = false;
                NibblesLinkedList? current = nibblesHeader;
                while (!isEnd) {
                  if (index == current?.currentIndex) {
                    // 蛇体
                    return const NibblesBody();
                  } else {
                    current = current?.next;
                    if (current == null) isEnd = true;
                  }
                }

                // 豆豆
                if (core.pointNodeList.contains(index)) {
                  return Container(
                    color: Colors.purple,
                  );
                }
                if (config.obstacle.contains(index)) {
                  return Container(
                    color: Colors.white38,
                  );
                }

                // 棋盘
                final rowsIndex = (index / config.columnCount).floor();
                final rowsColors1 = [Colors.amberAccent, Colors.blueAccent];
                final rowsColors2 = [Colors.blueAccent, Colors.amberAccent];
                final colors = rowsIndex.isOdd ? rowsColors1 : rowsColors2;
                return Container(
                  color: index.isEven ? colors[0] : colors[1],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class NibblesBody extends StatelessWidget {
  const NibblesBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.redAccent,
    );
  }
}
