import 'package:flutter/material.dart';
import 'package:love_debate/features/detail/widgets/energy_progress_bar.dart';
import 'package:love_debate/widgets/custom_app_bar.dart';

class DetailPage extends StatelessWidget {
  final String debateId;
  const DetailPage({super.key, required this.debateId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(onBackPressed: () {
        Navigator.pop(context);
      }),
      body: Column(
        children: [
          // 对方辩手
          Container(
            padding: const EdgeInsets.symmetric(vertical: 22),
            decoration: BoxDecoration(
              color: const Color(0xFFFECE65).withOpacity(0.1),
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xFFFECE65).withOpacity(0.3),
                  width: 2,
                ),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // 四个头像
                  children: [
                    ...List.generate(
                        4,
                        (index) => Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 24),
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1A121F),
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: const Color(0xFFFECE65),
                                        width: 1.5),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.asset(
                                      'assets/images/avatar.jpg',
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(Icons.person,
                                            color: Color(0xFFFECE65));
                                      },
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(5),
                                      ),
                                    ),
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFECE65),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            '反方',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 100, // 设置固定的宽度
                          child: Text(
                            '奥斯卡胡桂奥斯卡胡桂民民',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),

          // 回合进度展示
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: const Color(0xFF130E16),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                // 顶部回合信息
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
                          child: const SizedBox(
                            height: 10,
                            child: EnergyProgressBar(
                              myEnergy: 0.7, // 假数据：正方占比70%
                              opponentEnergy: 0.3, // 假数据：反方占比30%
                              myColor: Color(0xFF8A63A6), // 正方颜色
                              opponentColor: Color(0xFFF6D072), // 反方颜色
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
        ],
      ),
    );
  }
}
