import 'dart:developer';
import 'dart:math' as math;

import 'package:nibbles/core/game_exception.dart';
import 'package:nibbles/core/obstacle_detect.dart';
import 'package:nibbles/core/game_config.dart';
import 'package:nibbles/core/nibbles_linked_list.dart';

typedef OnScoreChange = void Function(int score);

class NibblesCore {
  NibblesCore(
    this.linkedList,
    this.config, {
    this.onScoreChange,
  }) {
    linkedList.core = this;
  }

  final directionConflictMap = {
    Direction.right: Direction.left,
    Direction.left: Direction.right,
    Direction.up: Direction.down,
    Direction.down: Direction.up,
  };
  // 蛇头节点
  NibblesLinkedList linkedList;
  GameConfig config;
  List<int> pointNodeList = [];
  OnScoreChange? onScoreChange;
  int _score = -1;

  ObstacleDetect get obstacle => ObstacleDetect(config);
  Map<Direction, int> get directionStepMap => {
        Direction.right: 1,
        Direction.left: -1,
        Direction.up: -config.columnCount,
        Direction.down: config.columnCount,
      };
  Map<Direction, List<int>> get directionObstacleMap => {
        Direction.right: obstacle.right,
        Direction.left: obstacle.left,
        Direction.up: obstacle.top,
        Direction.down: obstacle.bottom,
      };

  Direction? move(Direction dir) {
    // 冲突的方向
    final directionConflict = directionConflictMap[dir];
    // 这个方向下的移动数据
    final directionStep = directionStepMap[dir];
    // 方向边界
    final directionObstacle = directionObstacleMap[dir];
    // 蛇的全部身体节点数据
    final List<int> dataList = [];
    // 蛇的最后一个节点
    final last = linkedList.getLast((current) {
      dataList.add(current.currentIndex);
    });
    if (linkedList.direction == directionConflict) {
      move(linkedList.direction!);
      return linkedList.direction!;
    } else {
      linkedList.direction = dir;
    }
    final nextIndex = linkedList.currentIndex + directionStep!;
    // 判断是否触碰到边界
    if (directionObstacle!.contains(nextIndex)) {
      throw GameException(
        state: GameState.obstacleConflict,
        message: '到达边界',
      );
    }
    // 判断是否碰撞到自身
    if (dataList.contains(nextIndex)) {
      throw GameException(
        state: GameState.selfConflict,
        message: '碰撞到自身',
      );
    }
    linkedList.move(nextIndex);
    if (pointNodeList.contains(nextIndex)) {
      last.next = NibblesLinkedList(last.currentIndex);
      generatePointNode();
      if (_score >= config.itemCount) {
        throw GameException(
          state: GameState.win,
          message: '胜利！',
        );
      }
    }
    return null;
  }

  // 生成豆豆
  generatePointNode() {
    _score++;
    final rand = math.Random();
    // 障碍占据的点 蛇和游戏障碍物
    final List<int> obstacleDataList = [...obstacle.gameObstacle];

    // 地图的全部点
    final mapDataList = List.generate(config.itemCount, (index) => index);
    // 空白的地图点
    final emptyDataList = [];
    linkedList.getLast((current) {
      obstacleDataList.add(current.currentIndex);
    });
    for (var element in mapDataList) {
      final index = obstacleDataList.indexOf(element);
      if (index == -1) {
        emptyDataList.add(element);
      }
    }
    if (emptyDataList.isNotEmpty) {
      final randomIndex = rand.nextInt(emptyDataList.length);
      pointNodeList = [emptyDataList[randomIndex]];
    } else {
      pointNodeList = [];
    }
    if (onScoreChange != null) {
      onScoreChange!(_score);
    }
  }
}
