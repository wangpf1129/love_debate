import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:love_debate/models/index.dart';
import 'package:love_debate/providers/api_providers.dart';
import 'package:love_debate/widgets/custom_app_bar.dart';

class ResultPage extends HookConsumerWidget {
  final String debateId;
  const ResultPage({super.key, required this.debateId});
  static const winBg =
      'https://oss.6pen.art/love-debate-mini/result-win-bg.png';
  static const loseBg =
      'https://oss.6pen.art/love-debate-mini/result-lose-bg.png';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debateDetailAsync =
        ref.watch(fetchDebateDetailProvider(debateId, keyname: 'result_page'));
    useEffect(() {
      final timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        if (context.mounted) {
          if (debateDetailAsync.value != null &&
              debateDetailAsync.value!.state == DebateState.grading) {
            ref.invalidate(
                fetchDebateDetailProvider(debateId, keyname: 'result_page'));
          } else {
            timer.cancel();
          }
        }
      });
      return timer.cancel;
    }, []);

    return Scaffold(
      appBar: CustomAppBar(
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: debateDetailAsync.when(
        error: (error, stack) {
          print(error);
          print(stack);
          return const Center(child: Text('加载失败'));
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (debateDetail) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      '分享结果',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('辩论记录'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('再来一把'),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                height: 64,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: debateDetail.result == DebateResult.win
                        ? const NetworkImage(winBg)
                        : const NetworkImage(loseBg),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      debateDetail.state == DebateState.grading
                          ? '正在评分...'
                          : debateDetail.resultText,
                      style: TextStyle(
                        color: debateDetail.result == DebateResult.win
                            ? const Color(0xFFFECE65)
                            : debateDetail.result == DebateResult.lose
                                ? const Color(0xFF9261A9)
                                : const Color(0xFFFECE65),
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      color: const Color(0xFF8a63a6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            debateDetail.themeTitle,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '你的观点：${debateDetail.my.standpointView}',
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w600),
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
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/images/result-content-bg.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
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
                                // 我方辩手
                                Row(
                                  children: List.generate(
                                      debateDetail.my.bots.length,
                                      (index) => Container(
                                            margin:
                                                const EdgeInsets.only(right: 4),
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color:
                                                      const Color(0xFF9261A9),
                                                  width: 1.5),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: Image.network(
                                                debateDetail
                                                    .my.bots[index].botAvatar,
                                                width: 30,
                                                height: 30,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )),
                                ),
                                // 对方辩手
                                Row(
                                  children: List.generate(
                                      debateDetail.opponent.bots.length,
                                      (index) => Container(
                                            margin:
                                                const EdgeInsets.only(right: 4),
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color:
                                                      const Color(0xFFf6d072),
                                                  width: 1.5),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: Image.network(
                                                debateDetail.opponent
                                                    .bots[index].botAvatar,
                                                width: 30,
                                                height: 30,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )),
                                )
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              //  裁判怎么说, 文本靠左
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '裁判怎么说',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // 裁判评论列表
              Expanded(
                child: ListView.builder(
                  itemCount: debateDetail.judges.length,
                  itemBuilder: (context, index) {
                    final judge = debateDetail.judges[index];
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.transparent,
                          width: 2,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              judge.botAvatar,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stack) {
                                return Container(
                                  width: 40,
                                  height: 40,
                                  color: Colors.grey.shade800,
                                  child: const Icon(Icons.person,
                                      size: 20, color: Colors.white),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(judge.botName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      debateDetail.state == DebateState.grading
                                          ? '裁判正在评分中，请稍候...'
                                          : judge.content ?? '',
                                      style: const TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
