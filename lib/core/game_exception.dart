import 'package:nibbles/core/game_config.dart';

// 游戏异常
class GameException implements Exception {
  GameException({
    required this.state,
    required this.message,
  });
  GameState state;
  String message;
}
