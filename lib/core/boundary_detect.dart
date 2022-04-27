import 'package:nibbles/core/game_config.dart';

// 边界检测
class BoundaryDetect {
  BoundaryDetect(this._config);
  final GameConfig _config;

  // 边界索引
  List<int> get top => List.generate(_config.columnCount, (index) => index);
  List<int> get bottom => List.generate(
        _config.columnCount,
        (index) => _config.columnCount * (_config.rowCount - 1) + index,
      );
  List<int> get left => List.generate(
        _config.rowCount,
        (index) => index * _config.columnCount,
      );
  List<int> get right => List.generate(
        _config.rowCount,
        (index) => (index + 1) * _config.columnCount - 1,
      );
}
