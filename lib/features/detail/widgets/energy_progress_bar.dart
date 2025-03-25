import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:love_debate/hooks/use_previous_distinct.dart';

class EnergyProgressBar extends HookWidget {
  final double myEnergy; // 我方能量值 (0.0 到 1.0)
  final double opponentEnergy; // 对方能量值 (0.0 到 1.0)
  final Color myColor; // 我方颜色
  final Color opponentColor; // 对方颜色
  final Duration animationDuration; // 动画持续时间

  const EnergyProgressBar({
    super.key,
    required this.myEnergy,
    required this.opponentEnergy,
    required this.myColor,
    required this.opponentColor,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      print(
          'EnergyProgressBar rebuild - myEnergy: $myEnergy, opponentEnergy: $opponentEnergy');
      return null;
    }, [myEnergy, opponentEnergy]);
    // 使用 hooks 创建和管理动画控制器
    final animationController = useAnimationController(
      duration: animationDuration,
      initialValue: 1.0,
    );

    // 使用内置的 usePreviousDistinct 钩子获取前一个值
    final previousMyEnergy = usePreviousDistinct<double>(myEnergy);
    final previousOpponentEnergy = usePreviousDistinct<double>(opponentEnergy);

    useEffect(() {
      if ((previousMyEnergy != null && previousMyEnergy != myEnergy) ||
          (previousOpponentEnergy != null &&
              previousOpponentEnergy != opponentEnergy)) {
        animationController.forward(from: 0.0);
      }
      return null;
    }, [myEnergy, opponentEnergy]);

    // 创建动画对象
    final myEnergyAnimation = useMemoized(() {
      return Tween<double>(
        begin: previousMyEnergy ?? myEnergy,
        end: myEnergy,
      ).animate(CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ));
    }, [previousMyEnergy, myEnergy, animationController]);

    final opponentEnergyAnimation = useMemoized(() {
      return Tween<double>(
        begin: previousOpponentEnergy ?? opponentEnergy,
        end: opponentEnergy,
      ).animate(CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ));
    }, [previousOpponentEnergy, opponentEnergy, animationController]);

    // 使用 useAnimation 钩子访问动画值
    final animatedMyEnergy = useAnimation(myEnergyAnimation);
    final animatedOpponentEnergy = useAnimation(opponentEnergyAnimation);

    return CustomPaint(
      painter: EnergyProgressPainter(
        myEnergy: animatedMyEnergy,
        opponentEnergy: animatedOpponentEnergy,
        myColor: myColor,
        opponentColor: opponentColor,
      ),
      child: Container(), // 空容器作为画布
    );
  }
}

class EnergyProgressPainter extends CustomPainter {
  final double myEnergy;
  final double opponentEnergy;
  final Color myColor;
  final Color opponentColor;

  EnergyProgressPainter({
    required this.myEnergy,
    required this.opponentEnergy,
    required this.myColor,
    required this.opponentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // 计算分割点位置
    final dividerPosition = width * myEnergy;
    final skewOffset = height / 2; // 斜线偏移量

    // 绘制背景（可选）
    final bgPaint = Paint()..color = Colors.black.withOpacity(0.2);
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), bgPaint);

    // 绘制我方进度条（左侧）
    if (myEnergy > 0) {
      final myPaint = Paint()..color = myColor;
      final myPath = Path()
        ..moveTo(0, 0)
        ..lineTo(dividerPosition, 0)
        ..lineTo(dividerPosition + skewOffset, height)
        ..lineTo(0, height)
        ..close();

      canvas.drawPath(myPath, myPaint);
    }

    // 绘制对方进度条（右侧）
    if (opponentEnergy > 0) {
      final opponentPaint = Paint()..color = opponentColor;
      final opponentPath = Path()
        ..moveTo(width, 0)
        ..lineTo(dividerPosition, 0)
        ..lineTo(dividerPosition + skewOffset, height)
        ..lineTo(width, height)
        ..close();

      canvas.drawPath(opponentPath, opponentPaint);
    }
  }

  @override
  bool shouldRepaint(covariant EnergyProgressPainter oldDelegate) {
    return oldDelegate.myEnergy != myEnergy ||
        oldDelegate.opponentEnergy != opponentEnergy ||
        oldDelegate.myColor != myColor ||
        oldDelegate.opponentColor != opponentColor;
  }
}
