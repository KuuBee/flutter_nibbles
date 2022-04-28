import 'dart:math' as math;

import 'package:nibbles/core/game_config.dart';

// 边界检测
class ObstacleDetect {
  ObstacleDetect(
    this._config,
  );
  final GameConfig _config;
  List<int> get gameObstacle => _config.obstacle;

  // 边界索引
  List<int> get top => [
        ...gameObstacle,
        ...List.generate(_config.columnCount, (index) => index)
      ];
  List<int> get bottom => [
        ...gameObstacle,
        ...List.generate(
          _config.columnCount,
          (index) => _config.columnCount * (_config.rowCount - 1) + index,
        )
      ];
  List<int> get left => [
        ...gameObstacle,
        ...List.generate(
          _config.rowCount,
          (index) => index * _config.columnCount,
        )
      ];
  List<int> get right => [
        ...gameObstacle,
        ...List.generate(
          _config.rowCount,
          (index) => (index + 1) * _config.columnCount - 1,
        )
      ];
}
