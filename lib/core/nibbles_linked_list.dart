// 移动方向 上下左右
import 'dart:developer';

enum Direction {
  up,
  down,
  left,
  right,
}

class NibblesLinkedList {
  NibblesLinkedList(this.currentIndex, [this.direction = Direction.right]);
  // 当前的索引
  int currentIndex;
  // 下一个节点
  NibblesLinkedList? next;
  // 上一个节点
  NibblesLinkedList? perv;
  // 如果前面的节点没有的话 这个属性是必须的
  // 前进的方向
  Direction? direction;

  Direction? moveDirection(Direction dir, [int? step = 1]) {
    if (direction == null) return direction;
    Direction? returnDir;
    switch (dir) {
      case Direction.right:
        {
          if (direction == Direction.left) {
            returnDir = direction;
          } else {
            move(currentIndex + 1);
          }
          break;
        }
      case Direction.left:
        {
          if (direction == Direction.right) {
            returnDir = direction;
          } else {
            move(currentIndex - 1);
          }
          break;
        }
      case Direction.down:
        {
          if (direction == Direction.up) {
            returnDir = direction;
          } else {
            move(currentIndex + 10);
          }
          break;
        }
      case Direction.up:
        {
          if (direction == Direction.down) {
            returnDir = direction;
          } else {
            move(currentIndex - 10);
          }
          break;
        }
    }
    if (returnDir == null) {
      direction = dir;
    } else {
      moveDirection(returnDir);
    }
    return returnDir;
  }

  void move(int newIndex) {
    if (newIndex == currentIndex) return;
    next?.move(currentIndex);
    currentIndex = newIndex;
  }
}
