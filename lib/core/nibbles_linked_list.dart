import 'dart:developer';

import 'package:nibbles/core/game_config.dart';
import 'package:nibbles/core/game_exception.dart';
import 'package:nibbles/core/nibbles_core.dart';

typedef IterateCallback = void Function(NibblesLinkedList current);

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
  NibblesCore? core;

  get isHeader => direction != null;

  // 移动这个节点到新的位置 同时更新下一个节点
  void move(int newIndex) {
    List<int> dataList = [];
    final last = getLast((current) {
      dataList.add(current.currentIndex);
    });
    // 判断是否碰撞到自身
    if (isHeader && dataList.contains(newIndex)) {
      throw GameException(
        state: GameState.selfConflict,
        message: '碰撞到自身',
      );
    }
    if (newIndex == currentIndex) return;
    next?.move(currentIndex);
    currentIndex = newIndex;
    // 判断是否为分数点
    if (core?.pointNodeList == null) return;
    if (core!.pointNodeList.contains(newIndex)) {
      last.next = NibblesLinkedList(last.currentIndex);
      core!.generatePointNode();
      if (core?.pointNodeList.isEmpty ?? false) {
        throw GameException(
          state: GameState.win,
          message: '胜利！',
        );
      }
    }
  }

  // 获取最后一个节点并且提供一个每次迭代的回调
  NibblesLinkedList getLast([IterateCallback? callback]) {
    bool isEnd = false;
    NibblesLinkedList currentNibble = this;
    while (!isEnd) {
      if (callback != null) callback(currentNibble);
      if (currentNibble.next != null) {
        currentNibble = currentNibble.next!;
      } else {
        isEnd = true;
      }
    }
    return currentNibble;
  }
}
