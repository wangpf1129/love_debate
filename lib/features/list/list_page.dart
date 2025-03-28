import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:love_debate/features/create/create_page.dart';
import 'package:love_debate/features/detail/detail_page.dart';
import 'package:love_debate/features/match/match_page.dart';
import 'package:love_debate/features/result/result_page.dart';
import 'package:love_debate/models/index.dart';
import 'package:love_debate/providers/api_providers.dart';
import 'package:love_debate/widgets/primary_button.dart';

class ListPage extends ConsumerWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsAsync = ref.watch(fetchDebateRecordsProvider);

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
      body: recordsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF8a63a6),
          ),
        ),
        error: (error, stack) {
          print('error: $error');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('加载数据失败', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.refresh(fetchDebateRecordsProvider),
                  child: const Text('重新加载'),
                )
              ],
            ),
          );
        },
        data: (data) => RefreshIndicator(
          onRefresh: () => ref.refresh(fetchDebateRecordsProvider.future),
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final record = data[index];

              return InkWell(
                onTap: () {
                  // 根据record的状态来决定跳转到哪个页面
                  switch (record.state) {
                    case DebateState.fighting:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailPage(
                                  debateId: record.id,
                                )),
                      );
                      break;
                    case DebateState.finished:
                    case DebateState.grading:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResultPage(
                                  debateId: record.id,
                                )),
                      );
                      break;
                    case DebateState.preparing:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CreatePage(debateId: record.id)),
                      );
                      break;
                    default:
                      Fluttertoast.showToast(
                          msg: '意外的状态',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    // 默认情况下，跳转到一个通用的页面
                  }
                },
                child: Container(
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(10),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: const Color(0xFF32243B), width: 1.5),
                  ),
                  child: ClipRRect(
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
                              Flexible(
                                  child: Text(
                                record.themeTitle,
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                              )),
                              Text(
                                '你的观点：${record.my.standpointView}',
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
                            child: Column(
                              children: [
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('我方辩手'),
                                    Text('对手辩手'),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // 左右俩边各有四个头像
                                    Row(
                                      children: List.generate(
                                          4,
                                          (index) => Container(
                                                margin: const EdgeInsets.only(
                                                    right: 4),
                                                width: 30,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      color: const Color(
                                                          0xFF9261A9),
                                                      width: 1.5),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  child: record.my.bots.length >
                                                          index
                                                      ? Image.network(
                                                          record.my.bots[index]
                                                              .botAvatar,
                                                          fit: BoxFit.cover,
                                                          errorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            return const Icon(
                                                                Icons.person,
                                                                color: Color(
                                                                    0xFF9261A9));
                                                          },
                                                        )
                                                      : const Icon(Icons.person,
                                                          color: Color(
                                                              0xFF9261A9)), // 默认头像
                                                ),
                                              )),
                                    ),
                                    Row(
                                      children: List.generate(
                                          4,
                                          (index) => Container(
                                                margin: const EdgeInsets.only(
                                                    right: 4),
                                                width: 30,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      color: const Color(
                                                          0xFF9261A9),
                                                      width: 1.5),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  child: record.opponent.bots
                                                              .length >
                                                          index
                                                      ? Image.network(
                                                          record
                                                              .opponent
                                                              .bots[index]
                                                              .botAvatar,
                                                          fit: BoxFit.cover,
                                                          errorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            return const Icon(
                                                                Icons.person,
                                                                color: Color(
                                                                    0xFF9261A9));
                                                          },
                                                        )
                                                      : const Icon(Icons.person,
                                                          color: Color(
                                                              0xFF9261A9)), // 默认头像
                                                ),
                                              )),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(record.createdAt),
                                      Text(
                                        record.resultText ?? '',
                                        style: TextStyle(
                                          color: record.result ==
                                                  DebateResult.win
                                              ? const Color(0xFFfece65)
                                              : record.result ==
                                                      DebateResult.lose
                                                  ? const Color(0xFF8a63a6)
                                                  : record.result ==
                                                          DebateResult.fighting
                                                      ? const Color(0xFF2196f3)
                                                      : const Color(0xFF999999),
                                        ),
                                      ),
                                    ]),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
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
