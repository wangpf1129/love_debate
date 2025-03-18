import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:love_debate/features/create/widgets/strategy_dialog.dart';
import 'package:love_debate/widgets/custom_app_bar.dart';
import 'package:love_debate/widgets/primary_button.dart';

class CreatePage extends HookWidget {
  const CreatePage({super.key});

  void _showDialog(BuildContext context, ValueNotifier<String> strategyState) {
    showDialog(
      context: context,
      builder: (context) {
        return StrategyDialog(
          initialStrategy: strategyState.value,
          onStrategyChanged: (strategy) {
            strategyState.value = strategy;
            print('===== 状态已更新 =====');
            print('更新后的值: ${strategyState.value}');
            print('=====================');
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final strategyState = useState('');

    return Scaffold(
      appBar: CustomAppBar(onBackPressed: () {
        Navigator.pop(context);
      }),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/create_bg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/create_title.png',
                      height: 20,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '上班是否应该摸鱼',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 3.0,
                            color: Color.fromARGB(150, 0, 0, 0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                padding:
                    const EdgeInsets.symmetric(horizontal: 55, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF9261A9).withAlpha(25),
                      const Color(0xFF1A121F).withAlpha(15),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  border: const Border(
                    top: BorderSide(color: Color(0xFF9261A9), width: 2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF9261A9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        '正方',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const Text(
                      '你的立场',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const Text(
                      '应该',
                      style: TextStyle(
                        color: Color(0xFF9261A9),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Container(
                width: double.infinity,
                height: 300,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/create_modal_bg.png'),
                    fit: BoxFit.contain,
                    alignment: Alignment.topCenter,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(color: Colors.white),
                              children: [
                                TextSpan(
                                  text: '选择你的辩手',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(text: ''),
                                TextSpan(
                                  text: '（1/4）',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.add_circle_outline,
                            color: Color(0xFF9261A9),
                            size: 22,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                        text: const TextSpan(children: [
                      TextSpan(
                          text: '所有AI辩手均来自独响APP的公开AI,如果没有找到，你也可以',
                          style: TextStyle(
                              color: Color(0xFF5F4E6D), fontSize: 10)),
                      TextSpan(
                        text: '去独响创建',
                        style: TextStyle(
                          color: Color(0xFF9261A9),
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ])),
                    const SizedBox(height: 16),
                    // 需要水平有4个装头像的相框，69*100  相框之间有10的间距
                    Row(
                      spacing: 12,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        4,
                        (index) => Container(
                          width: 69,
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A121F),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Colors.white.withAlpha(20), width: 2),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF2a252d),
                          width: 4,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2), // 两层边框之间的间距
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF2a252d),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFF2a252d),
                              width: 1,
                            ),
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              _showDialog(context, strategyState);
                            },
                            child: const Text(
                              '设置辩论策略（进阶）',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              PrimaryButton(
                  text: '准备完毕',
                  onPressed: () {
                    print('===== 准备完毕 =====');
                  }),
              // const SizedBox(height: 320), // 增加高度避免重叠
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://oss.6pen.art/love-debate-mini/create-judge-bg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(
                          3,
                          (index) => Column(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF9261A9).withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.white.withAlpha(10),
                                    width: 2,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '评审$index',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
