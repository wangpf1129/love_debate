import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:math';

import 'package:love_debate/widgets/custom_app_bar.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> with TickerProviderStateMixin {
  late AnimationController _spinController;
  late AnimationController _reverseSpinController;
  late AnimationController _pulseController;
  late AnimationController _successController;
  late AnimationController _progressController;
  late AnimationController _particleController;

  bool matchSuccess = false;

  @override
  void initState() {
    super.initState();

    // 外层粒子环旋转动画
    _spinController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    // 内层环反向旋转动画
    _reverseSpinController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();

    // 中心脉冲点动画
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    // 匹配成功动画
    _successController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // 进度条动画控制器 - 持续5秒，与匹配成功时间一致
    _progressController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..forward(); // 立即开始进度动画

    // 粒子动画控制器
    _particleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    // 模拟5秒后匹配成功
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          matchSuccess = true;
        });
        _successController.forward();
      }
    });
  }

  @override
  void dispose() {
    _spinController.dispose();
    _reverseSpinController.dispose();
    _pulseController.dispose();
    _successController.dispose();
    _progressController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Stack(
        children: [
          // 背景粒子特效
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ParticlesPainter(_particleController.value),
                );
              },
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 匹配动画
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Stack(
                    children: [
                      // 外层粒子环
                      AnimatedBuilder(
                        animation: _spinController,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _spinController.value * 2 * math.pi,
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  center: Alignment.topCenter,
                                  radius: 0.9,
                                  colors: [
                                    Color(0xFFFECE65), // 黄色
                                    Color(0xFF9261A9), // 紫色
                                    Colors.transparent,
                                  ],
                                  stops: [0.0, 0.15, 0.5],
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      // 内层旋转环 - 重构为单一黄色线
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: AnimatedBuilder(
                            animation: _reverseSpinController,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle:
                                    -_reverseSpinController.value * 2 * math.pi,
                                child: CustomPaint(
                                  painter: ArcPainter(),
                                  size: const Size(140, 140),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // 中心脉冲点
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.all(70),
                          child: AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF9261A9),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFFECE65).withAlpha(
                                          ((0.5 +
                                                      _pulseController.value *
                                                          0.5) *
                                                  255)
                                              .round()),
                                      blurRadius:
                                          10 + _pulseController.value * 10,
                                      spreadRadius:
                                          2 + _pulseController.value * 2,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // 匹配成功动画
                      ScaleTransition(
                        scale: _successController,
                        child: FadeTransition(
                          opacity: _successController,
                          child: const Center(
                            child: Text(
                              "✓",
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFECE65),
                                shadows: [
                                  Shadow(
                                    color: Color(0xFFFECE65),
                                    blurRadius: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // 文字动画效果
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    matchSuccess ? '发现强劲的对手！' : '正在寻找对手...',
                    key: ValueKey<bool>(matchSuccess),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // 进度条
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AnimatedBuilder(
                      animation: _progressController,
                      builder: (context, child) {
                        return LinearProgressIndicator(
                          value: matchSuccess ? 1.0 : _progressController.value,
                          color: const Color(0xFF9261A9),
                          backgroundColor: Colors.grey,
                          minHeight: 10,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // 状态指示文字
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.0, 0.5),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    matchSuccess ? '🎉匹配成功！' : '匹配中...',
                    key: ValueKey<bool>(matchSuccess),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFFFECE65),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 弧线绘制器
class ArcPainter extends CustomPainter {
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
  final Random random = Random();

  ParticlesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final int particleCount = 20;

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
