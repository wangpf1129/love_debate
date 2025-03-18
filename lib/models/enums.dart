// 辩论状态枚举
import 'package:freezed_annotation/freezed_annotation.dart';

enum DebateState {
  @JsonValue('matching')
  matching, // 匹配中
  @JsonValue('preparing')
  preparing, // 准备中
  @JsonValue('fighting')
  fighting, // 战斗中
  @JsonValue('grading')
  grading, // 评分中
  @JsonValue('finished')
  finished, // 已结束
}

// 结果枚举
enum DebateResult {
  @JsonValue('win')
  win, // 胜利
  @JsonValue('lose')
  lose, // 失败
  @JsonValue('preparing')
  preparing; // 准备中
}

// 立场枚举
enum DebateStandpoint {
  @JsonValue('pros')
  pros, // 正方
  @JsonValue('cons')
  cons; // 反方
}
