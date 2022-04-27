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
    timeInterval: const Duration(milliseconds: 100),
  );
  late final FocusNode node;
  late final NibblesLinkedList nibblesHeader = NibblesLinkedList(
    44,
    Direction.right,
  );
  late final NibblesCore core = NibblesCore(nibblesHeader, config);
  Direction currentDirection = Direction.right;

  @override
  initState() {
    NibblesLinkedList root1 = NibblesLinkedList(43);
    NibblesLinkedList root2 = NibblesLinkedList(42);
    NibblesLinkedList root3 = NibblesLinkedList(41);
    NibblesLinkedList root4 = NibblesLinkedList(40);
    root1.next = root2;
    root2.next = root3;
    root3.next = root4;
    nibblesHeader.next = root1;
    node = FocusNode(
      debugLabel: 'move',
      onKey: onKey,
    );
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
                  return const NibblesBody();
                } else {
                  current = current?.next;
                  if (current == null) isEnd = true;
                }
              }
              final rowsIndex = (index / config.columnCount).floor();
              final rowsColors1 = [Colors.amberAccent, Colors.blueAccent];
              final rowsColors2 = [Colors.blueAccent, Colors.amberAccent];
              final colors = rowsIndex.isOdd ? rowsColors1 : rowsColors2;
              return Container(
                color: index.isEven ? colors[0] : colors[1],
                // child: Center(
                //   child: FittedBox(
                //     child: Text(
                //       index.toString(),
                //     ),
                //   ),
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
