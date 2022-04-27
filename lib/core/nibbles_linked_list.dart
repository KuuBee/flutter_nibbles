import 'package:nibbles/core/game_config.dart';

// 蛇的数据结构 链表

class NibblesLinkedList {
  NibblesLinkedList(
    this.currentIndex, [
    this.direction,
  ]);
  // 当前的索引
  int currentIndex;
  // 下一个节点
  NibblesLinkedList? next;
  // 上一个节点
  NibblesLinkedList? perv;
  // 如果是蛇头的话 这个属性是必须的
  // 前进的方向
  Direction? direction;

  // 移动这个节点到新的位置 同时更新下一个节点
  void move(int newIndex) {
    if (newIndex == currentIndex) return;
    next?.move(currentIndex);
    currentIndex = newIndex;
  }
}
