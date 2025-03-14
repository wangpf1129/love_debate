import 'package:flutter/material.dart';
import 'package:love_debate/features/match/match_page.dart';
import 'package:love_debate/widgets/primary_button.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                iconSize: 16,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )),
        title: Image.asset(
          'assets/images/logo.png',
          height: 47,
          fit: BoxFit.contain,
        ),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(10),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF32243B), width: 1.5),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  color: const Color(0xFF8a63a6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '上班是否应该摸鱼',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '你的观点： 应该',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
                DefaultTextStyle(
                  style: const TextStyle(
                    color: Color(0xFF8a63a6),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 12),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('我方辩手'),
                            Text('对手辩手'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 左右俩边各有四个头像
                            Row(
                              children: List.generate(
                                  4,
                                  (index) => Container(
                                        margin: const EdgeInsets.only(right: 4),
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              color: const Color(0xFF9261A9),
                                              width: 1.5),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: Image.asset(
                                            'assets/images/avatar.jpg',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )),
                            ),
                            Row(
                              children: List.generate(
                                  4,
                                  (index) => Container(
                                        margin: const EdgeInsets.only(right: 4),
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              color: const Color(0xFF9261A9),
                                              width: 1.5),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: Image.asset(
                                            'assets/images/avatar.jpg',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('2024.12.23 23:45:00'),
                            Text('该死，输了'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PrimaryButton(
          text: '开始匹配',
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MatchPage()));
          },
        ),
      ),
    );
  }
}
