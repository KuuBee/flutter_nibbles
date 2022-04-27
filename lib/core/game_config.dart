// 可操作方向
enum Direction {
  up,
  down,
  left,
  right,
}

// 游戏配置
class GameConfig {
  GameConfig({
    this.baseWidth = 10.0,
    this.baseHeight = 10.0,
    this.rowCount = 30,
    this.columnCount = 30,
    this.timeInterval = const Duration(milliseconds: 300),
  });
  // 基础宽度
  double baseWidth;
  // 基础高度
  double baseHeight;
  // 棋盘行数
  int rowCount;
  // 棋盘列数
  int columnCount;
  Duration timeInterval;
  // 渲染块数量
  get itemCount => rowCount * columnCount;
  // 棋盘高度
  get height => baseHeight * rowCount;
  // 棋盘宽度
  get width => baseWidth * columnCount;
}
