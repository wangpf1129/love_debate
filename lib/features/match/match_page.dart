import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:love_debate/features/create/create_page.dart';
import 'package:love_debate/features/match/widgets/painter.dart';
import 'package:love_debate/models/enums.dart';
import 'package:love_debate/providers/api_providers.dart';
import 'dart:math' as math;

import 'package:love_debate/widgets/custom_app_bar.dart';

class MatchPage extends HookConsumerWidget {
  const MatchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 使用hooks创建动画控制器
    final spinController = useAnimationController(
      duration: const Duration(seconds: 8),
    )..repeat();

    final reverseSpinController = useAnimationController(
      duration: const Duration(seconds: 5),
    )..repeat();

    final pulseController = useAnimationController(
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    final successController = useAnimationController(
      duration: const Duration(milliseconds: 500),
    );

    final progressController = useAnimationController(
      duration: const Duration(seconds: 5),
    )..forward();

    final particleController = useAnimationController(
      duration: const Duration(seconds: 3),
    )..repeat();

    // 使用useState代替状态变量
    final matchResult = useState<MatchDebateResult?>(null);
    final matchLoading = useState(false);

    // 导航到创建页面的函数
    void navigateToCreatePage() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CreatePage()),
      );
    }

    final matchResultAsync = ref.watch(matchDebateProvider);

    // 使用useEffect处理副作用，类似于componentDidMount和componentWillUnmount
    useEffect(() {
      matchResultAsync.when(
        data: (data) {
          matchResult.value = MatchDebateResult.success;
          successController.forward();

          Future.delayed(const Duration(seconds: 1), () {
            navigateToCreatePage();
          });
        },
        error: (error, stack) {
          matchResult.value = MatchDebateResult.failed;
          print(error);
          print(stack);
        },
        loading: () {
          matchLoading.value = true;
        },
      );
      return null;
    }, [matchResultAsync]);

    void retryMatching() {
      matchResult.value = null;
      matchLoading.value = false;
      progressController.reset();
      progressController.forward();
      // ignore: unused_result
      ref.refresh(matchDebateProvider);
    }

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
              animation: particleController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ParticlesPainter(particleController.value),
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
                        animation: spinController,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: spinController.value * 2 * math.pi,
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

                      // 内层旋转环
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: AnimatedBuilder(
                            animation: reverseSpinController,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle:
                                    -reverseSpinController.value * 2 * math.pi,
                                child: CustomPaint(
                                  painter: ArcPainter(
                                    reverseSpinController.value,
                                  ),
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
                            animation: pulseController,
                            builder: (context, child) {
                              return Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF9261A9),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFFECE65).withAlpha(
                                          ((0.5 + pulseController.value * 0.5) *
                                                  255)
                                              .round()),
                                      blurRadius:
                                          10 + pulseController.value * 10,
                                      spreadRadius:
                                          2 + pulseController.value * 2,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // 匹配成功动画
                      if (matchResult.value == MatchDebateResult.success)
                        ScaleTransition(
                          scale: successController,
                          child: FadeTransition(
                            opacity: successController,
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

                      if (matchResult.value == MatchDebateResult.failed)
                        const Center(
                          child: Text(
                            "✗",
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              shadows: [
                                Shadow(
                                  color: Colors.red,
                                  blurRadius: 15,
                                ),
                              ],
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
                    matchResult.value == MatchDebateResult.success
                        ? '发现强劲的对手！'
                        : matchResult.value == MatchDebateResult.failed
                            ? '匹配失败，请重试'
                            : '正在寻找对手...',
                    key: ValueKey<String>(
                        matchResult.value == MatchDebateResult.success
                            ? 'success'
                            : matchResult.value == MatchDebateResult.failed
                                ? 'failed'
                                : 'matching'),
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
                      animation: progressController,
                      builder: (context, child) {
                        return LinearProgressIndicator(
                          value: matchResult.value == MatchDebateResult.success
                              ? 1.0
                              : matchResult.value == MatchDebateResult.failed
                                  ? 0.0
                                  : progressController.value,
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
                  child: matchResult.value == MatchDebateResult.failed
                      ? Column(
                          children: [
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                retryMatching();
                              },
                              child: const Text(
                                '重试',
                                key: ValueKey<String>('failed'),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Text(
                          matchResult.value == MatchDebateResult.success
                              ? '🎉匹配成功！'
                              : '匹配中...',
                          key: ValueKey<String>(
                              matchResult.value == MatchDebateResult.success
                                  ? 'success'
                                  : 'matching'),
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
