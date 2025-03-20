// 弧线绘制器
import 'dart:math' as math;
import 'dart:math';
import 'package:flutter/material.dart';

class ArcPainter extends CustomPainter {
  final double animationValue;

  ArcPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFFFECE65)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // 画一个180度的弧线（半圆）
    canvas.drawArc(
      rect,
      0, // 起始角度
      math.pi, // 180度弧线
      false, // 不填充
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 粒子特效绘制器
class ParticlesPainter extends CustomPainter {
  final double animationValue;
  final Random random = math.Random();

  ParticlesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    const int particleCount = 20;

    for (int i = 0; i < particleCount; i++) {
      final double offsetX = random.nextDouble() * size.width;
      final double offsetY =
          (random.nextDouble() * size.height) + (animationValue * size.height);
      final double modY = offsetY % size.height;

      final double opacity = random.nextDouble() * 0.5;
      final double particleSize = random.nextDouble() * 3 + 1;

      final Paint paint = Paint()
        ..color = Color.lerp(
          const Color(0xFFFECE65),
          const Color(0xFF9261A9),
          random.nextDouble(),
        )!
            .withOpacity(opacity);

      canvas.drawCircle(
        Offset(offsetX, modY),
        particleSize,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ParticlesPainter oldDelegate) {
    return animationValue != oldDelegate.animationValue;
  }
}
