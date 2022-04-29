import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nibbles/core/game_config.dart';
import 'package:nibbles/core/nibbles_core.dart';
import 'package:nibbles/core/nibbles_linked_list.dart';

class NibblesWidget extends StatefulWidget {
  const NibblesWidget({Key? key, required this.config}) : super(key: key);
  final GameConfig config;

  @override
  State<NibblesWidget> createState() => _NibblesWidgetState();
}

class _NibblesWidgetState extends State<NibblesWidget> {
  late final config = widget.config;
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
        // TODO 需要判断一下这个error的类型
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
              const rowsColors1 = [Color(0xFFEDD97E), Color(0xFF7FC5E3)];
              const rowsColors2 = [Color(0xFF7FC5E3), Color(0xFFEDD97E)];
              List<Color> colors;
              if (config.columnCount.isEven) {
                colors = rowsIndex.isOdd ? rowsColors1 : rowsColors2;
              } else {
                colors = rowsColors1;
              }
              return Container(
                color: colors[index.isEven ? 0 : 1],
                // child: FittedBox(
                //   child: Text(index.toString()),
                // ),
              );
            },
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
