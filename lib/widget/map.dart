import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:nibbles/core/game_config.dart';
import 'package:nibbles/core/game_exception.dart';
import 'package:nibbles/core/nibbles_core.dart';
import 'package:nibbles/core/nibbles_linked_list.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

class NibblesWidget extends StatefulWidget {
  const NibblesWidget({
    Key? key,
    required this.config,
    this.onScoreChange,
  }) : super(key: key);
  final GameConfig config;
  final OnScoreChange? onScoreChange;

  @override
  State<NibblesWidget> createState() => _NibblesWidgetState();
}

class _NibblesWidgetState extends State<NibblesWidget> {
  final node = FocusNode();
  late final config = widget.config;
  late final startDialogWidget = Stack(
    fit: StackFit.expand,
    children: [
      Center(
        child: Container(
          width: 200,
          height: 200,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '贪吃蛇',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                '方向键或滑动控制',
              ),
              const SizedBox(
                height: 30.0,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                ),
                onPressed: () {
                  core.generatePointNode();
                  currentDirection = Direction.right;
                  Timer(const Duration(milliseconds: 500), init);
                  SmartDialog.dismiss();
                },
                child: const Text('开始游戏'),
              ),
            ],
          ),
        ),
      ),
      if (!kIsWeb)
        if (Platform.isWindows || Platform.isMacOS || Platform.isLinux)
          Positioned(
            top: 0,
            left: 0,
            child: SizedBox(
              width: appWindow.size.width,
              height: appWindow.titleBarHeight,
              child: MoveWindow(),
            ),
          )
    ],
  );

  late NibblesCore core = NibblesCore(
    nibblesHeader,
    config,
    onScoreChange: onScoreChange,
  );
  late NibblesLinkedList nibblesHeader = NibblesLinkedList(
    initIndex,
    Direction.right,
  );
  bool isWin = false;
  int score = 0;
  Direction currentDirection = Direction.right;

  // 初始化的索引
  get initIndex =>
      (config.itemCount / 2).floor() - (config.columnCount / 3).floor();

  @override
  initState() {
    super.initState();
    Timer.run(() {
      start();
    });
  }

  start() {
    SmartDialog.show(
      backDismiss: false,
      clickBgDismissTemp: false,
      isLoadingTemp: false,
      widget: startDialogWidget,
    );
  }

  restart() {
    SmartDialog.show(
      backDismiss: false,
      clickBgDismissTemp: false,
      isLoadingTemp: false,
      widget: Container(
        width: 200,
        height: 150,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isWin)
              const Text(
                '你赢了！',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(
              height: 10,
            ),
            Text('本次得分:$score'),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.redAccent),
              ),
              onPressed: () {
                isWin = false;
                score = 0;
                nibblesHeader = NibblesLinkedList(
                  initIndex,
                  Direction.right,
                );
                core = NibblesCore(
                  nibblesHeader,
                  config,
                  onScoreChange: onScoreChange,
                );
                core.generatePointNode();
                currentDirection = Direction.right;
                setState(() {
                  // 重新初始化一下
                  Timer(const Duration(milliseconds: 500), init);
                });
                SmartDialog.dismiss();
              },
              child: const Text('再来一次'),
            ),
          ],
        ),
      ),
    );
  }

  // 初始化游戏循环
  init() {
    Timer.periodic(config.timeInterval, (timer) {
      try {
        setState(() {
          final returnDir = core.move(currentDirection);
          if (returnDir != null) currentDirection = returnDir;
        });
      } catch (error) {
        timer.cancel();
        if (error is GameException) {
          log(error.message);
          if (error.state == GameState.win) {
            isWin = true;
          }
          restart();
          return;
        }
        rethrow;
      }
    });
  }

  KeyEventResult moveDirection(int keyId) {
    switch (keyId) {
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

  onScoreChange(int data) {
    score = data;
    if (widget.onScoreChange != null) widget.onScoreChange!(data);
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = config.itemCount;
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.delta.dy > 0) {
          moveDirection(LogicalKeyboardKey.arrowDown.keyId);
        } else {
          moveDirection(LogicalKeyboardKey.arrowUp.keyId);
        }
      },
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 0) {
          moveDirection(LogicalKeyboardKey.arrowRight.keyId);
        } else {
          moveDirection(LogicalKeyboardKey.arrowLeft.keyId);
        }
      },
      child: KeyboardListener(
        focusNode: node,
        autofocus: true,
        onKeyEvent: (value) {
          moveDirection(value.logicalKey.keyId);
        },
        child: Container(
          color: Colors.blueAccent,
          width: config.width,
          height: config.height,
          child: GridView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: config.columnCount,
              childAspectRatio: 1.0,
            ),
            itemCount: itemCount,
            itemBuilder: (context, index) {
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
                child: Builder(
                  builder: (context) {
                    bool isEnd = false;
                    NibblesLinkedList? current = nibblesHeader;
                    while (!isEnd) {
                      if (index == current?.currentIndex) {
                        // 蛇体
                        return NibblesBody(
                          isHeader: current?.isHeader ?? false,
                        );
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
                    // 障碍物
                    if (config.obstacle.contains(index)) {
                      return Container(
                        color: Colors.white38,
                      );
                    }
                    return Container();
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class NibblesBody extends StatelessWidget {
  const NibblesBody({Key? key, this.isHeader = false}) : super(key: key);
  final bool isHeader;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(2),
      ),
      child: isHeader
          ? Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(999),
              ),
            )
          : Container(),
    );
  }
}
