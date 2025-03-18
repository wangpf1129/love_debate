import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:love_debate/api/api_server.dart';
import 'package:love_debate/api/http_server.dart';
import 'package:love_debate/features/match/match_page.dart';
import 'package:love_debate/models/index.dart';
import 'package:love_debate/widgets/primary_button.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<DebateRecord> _records = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchRecords();
  }

  // 获取数据
  Future<void> _fetchRecords() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await ApiServer.getBattleRecordList();
      setState(() {
        _records = data.data;
        isLoading = false;
      });
    } catch (e) {
      String errorMessage;
      if (e is BusinessException) {
        // 处理业务错误
        errorMessage = e.message; // 直接使用后端返回的 info
      } else {
        // 处理 HTTP 错误或其他错误
        errorMessage = e.toString();
      }
      Fluttertoast.showToast(
          msg: errorMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        isLoading = false;
      });
    }
  }

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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF8a63a6),
              ),
            )
          : ListView.builder(
              itemCount: _records.length,
              itemBuilder: (context, index) {
                final record = _records[index];

                return Container(
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
                              Text(
                                record.themeTitle,
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600),
                              ),
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
                                          color: record.state ==
                                                      DebateState.fighting ||
                                                  record.state ==
                                                      DebateState.grading
                                              ? (record.winnerUserId ==
                                                      record.my.userId
                                                  ? const Color(0xFFfece65)
                                                  : const Color(0xFF8a63a6))
                                              : record.state ==
                                                      DebateState.fighting
                                                  ? const Color(0xFF525252)
                                                  : record.state ==
                                                          DebateState.preparing
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
                );
              },
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
