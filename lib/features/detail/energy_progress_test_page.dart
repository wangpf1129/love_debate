import 'dart:async';
import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:love_debate/features/detail/widgets/energy_progress_bar.dart';

class EnergyProgressTestPage extends HookWidget {
  const EnergyProgressTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 使用useState管理能量值
    final myEnergy = useState<double>(0.7);
    final opponentEnergy = useState<double>(0.3);

    // 添加一个随机值函数，用于测试动画效果
    void randomizeEnergies() {
      // 生成随机值但确保总和为1.0
      final random = (Math.Random().nextDouble() * 0.4) + 0.3; // 0.3-0.7之间的随机值
      myEnergy.value = random;
      opponentEnergy.value = 1.0 - random;
    }

    // 模拟连续变化的效果
    final isContinuous = useState<bool>(false);

    useEffect(() {
      // 如果开启连续模式，创建定时器定期更新能量值
      Timer? timer;
      if (isContinuous.value) {
        timer = Timer.periodic(const Duration(seconds: 2), (_) {
          randomizeEnergies();
        });
      }

      return () {
        timer?.cancel();
      };
    }, [isContinuous.value]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('气势进度条测试'),
        backgroundColor: const Color(0xFF1A121F),
      ),
      body: Container(
        color: const Color(0xFF1A121F),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 显示当前能量值
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '当前能量值 - 正方: ${(myEnergy.value * 100).toStringAsFixed(1)}%, 反方: ${(opponentEnergy.value * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),

              // 能量进度条
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: const Color(0xFF130E16),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    // 顶部回合信息
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      color: const Color(0xFF2A252D),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '第3回合',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '总：3/8回合',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8A63A6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 双方气势进度条
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 24),
                      child: Row(
                        children: [
                          const Text(
                            '正方气势',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: SizedBox(
                                height: 10,
                                child: EnergyProgressBar(
                                  myEnergy: myEnergy.value,
                                  opponentEnergy: opponentEnergy.value,
                                  myColor: const Color(0xFF8A63A6),
                                  opponentColor: const Color(0xFFF6D072),
                                  animationDuration:
                                      const Duration(milliseconds: 500),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            '反方气势',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 控制按钮
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 增加正方气势按钮
                  ElevatedButton(
                    onPressed: () {
                      if (myEnergy.value < 0.9) {
                        myEnergy.value += 0.1;
                        opponentEnergy.value -= 0.1;
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8A63A6),
                    ),
                    child: const Text('增加正方气势'),
                  ),

                  const SizedBox(width: 16),

                  // 增加反方气势按钮
                  ElevatedButton(
                    onPressed: () {
                      if (opponentEnergy.value < 0.9) {
                        opponentEnergy.value += 0.1;
                        myEnergy.value -= 0.1;
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF6D072),
                    ),
                    child: const Text('增加反方气势'),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              // 随机变化按钮
              ElevatedButton(
                onPressed: randomizeEnergies,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
                child: const Text('随机变化'),
              ),

              const SizedBox(height: 16),
              // 连续播放开关
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('连续变化:', style: TextStyle(color: Colors.white)),
                  Switch(
                    value: isContinuous.value,
                    onChanged: (value) => isContinuous.value = value,
                    activeColor: Colors.teal,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
