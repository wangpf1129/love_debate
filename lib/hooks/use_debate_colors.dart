import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:love_debate/models/enums.dart';

class DebateColorScheme {
  final Color mainColor;
  final Color backgroundColor;
  final Color borderColor;
  final String label;

  DebateColorScheme({
    required this.mainColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.label,
  });
}

DebateColorScheme useDebateColors(
  DebateStandpoint standpoint, {
  double backgroundOpacity = 0.1,
  double borderOpacity = 0.3,
}) {
  return useMemoized(() {
    final Color mainColor = standpoint == DebateStandpoint.cons
        ? const Color(0xFFFECE65) // 反方黄色
        : const Color(0xFF8A63A6); // 正方紫色

    return DebateColorScheme(
      mainColor: mainColor,
      backgroundColor: mainColor.withOpacity(backgroundOpacity),
      borderColor: mainColor.withOpacity(borderOpacity),
      label: standpoint == DebateStandpoint.cons ? '反方' : '正方',
    );
  }, [standpoint, backgroundOpacity, borderOpacity]);
}
