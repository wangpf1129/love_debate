// 辩论状态枚举
enum DebateState {
  matching, // 匹配中
  preparing, // 准备中
  fighting, // 战斗中
  grading, // 评分中
  finished; // 已结束

  // 从字符串转换为枚举
  static DebateState fromString(String value) {
    return DebateState.values.firstWhere(
      (e) => e.name == value,
      orElse: () => DebateState.preparing,
    );
  }
}

// 结果枚举
enum DebateResult {
  win, // 胜利
  lose, // 失败
  preparing; // 准备中

  static DebateResult fromString(String value) {
    return DebateResult.values.firstWhere(
      (e) => e.name == value,
      orElse: () => DebateResult.preparing,
    );
  }
}

// 立场枚举
enum DebateStandpoint {
  pro, // 正方
  con; // 反方

  static DebateStandpoint fromString(String value) {
    return DebateStandpoint.values.firstWhere(
      (e) => e.name == value,
      orElse: () => DebateStandpoint.pro,
    );
  }
}
