import 'dart:developer';
import 'dart:math' as math;

import 'package:nibbles/core/obstacle_detect.dart';
import 'package:nibbles/core/game_config.dart';
import 'package:nibbles/core/nibbles_linked_list.dart';

class NibblesCore {
  NibblesCore(this.linkedList, this.config) {
    linkedList.core = this;
  }
  // 蛇头节点
  NibblesLinkedList linkedList;
  GameConfig config;
  List<int> pointNodeList = [];
  ObstacleDetect get obstacle => ObstacleDetect(config);

  // 按方向运动
  Direction? moveDirection(Direction dir, [int? step = 1]) {
    assert(linkedList.direction != null, 'direction 不能为 null');
    final direction = linkedList.direction;
    final currentIndex = linkedList.currentIndex;
    if (direction == null) return direction;
    Direction? returnDir;
    switch (dir) {
      case Direction.right:
        {
          if (direction == Direction.left) {
            returnDir = direction;
          } else {
            if (!obstacle.right.contains(linkedList.currentIndex)) {
              linkedList.move(currentIndex + 1);
            } else {
              throw Exception('到达边界');
            }
          }
          break;
        }
      case Direction.left:
        {
          if (direction == Direction.right) {
            returnDir = direction;
          } else {
            if (!obstacle.left.contains(linkedList.currentIndex)) {
              linkedList.move(currentIndex - 1);
            } else {
              throw Exception('到达边界');
            }
          }
          break;
        }
      case Direction.down:
        {
          if (direction == Direction.up) {
            returnDir = direction;
          } else {
            if (!obstacle.bottom.contains(linkedList.currentIndex)) {
              linkedList.move(currentIndex + config.columnCount);
            } else {
              throw Exception('到达边界');
            }
          }
          break;
        }
      case Direction.up:
        {
          if (direction == Direction.down) {
            returnDir = direction;
          } else {
            if (!obstacle.top.contains(linkedList.currentIndex)) {
              linkedList.move(currentIndex - config.columnCount);
            } else {
              throw Exception('到达边界');
            }
          }
          break;
        }
    }
    if (returnDir == null) {
      linkedList.direction = dir;
    } else {
      moveDirection(returnDir);
    }
    return returnDir;
  }

  // 生成豆豆
  generatePointNode() {
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
    final randomIndex = rand.nextInt(emptyDataList.length);
    pointNodeList = [emptyDataList[randomIndex]];
  }
}
