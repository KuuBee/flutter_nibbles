import 'dart:developer';

import 'package:nibbles/core/boundary_detect.dart';
import 'package:nibbles/core/game_config.dart';
import 'package:nibbles/core/nibbles_linked_list.dart';

class NibblesCore {
  NibblesCore(this.linkedList, this.config);
  // 蛇头
  NibblesLinkedList linkedList;
  GameConfig config;
  BoundaryDetect get boundary => BoundaryDetect(config);

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
            if (!boundary.right.contains(linkedList.currentIndex)) {
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
            if (!boundary.left.contains(linkedList.currentIndex)) {
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
            if (!boundary.bottom.contains(linkedList.currentIndex)) {
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
            if (!boundary.top.contains(linkedList.currentIndex)) {
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
}
