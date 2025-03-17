import 'package:flutter/material.dart';
import 'package:love_debate/api/api_server.dart';
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
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchRecords();
  }

  // 获取数据
  Future<void> _fetchRecords() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final data = await BattleRecordListApi.getBattleRecordList();
      setState(() {
        _records = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
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
      body: ListView.builder(
        itemCount: _records.length,
        itemBuilder: (context, index) {
          final record = _records[index];

          return Container(
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
                                          margin:
                                              const EdgeInsets.only(right: 4),
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
                                            child: record.my.bots.length > index
                                                ? Image.network(
                                                    record.my.bots[index]
                                                        .botAvatar,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
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
                                          margin:
                                              const EdgeInsets.only(right: 4),
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
                                            child: record.opponent.bots.length >
                                                    index
                                                ? Image.network(
                                                    record.opponent.bots[index]
                                                        .botAvatar,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(record.createdAt),
                              Text(record.resultText ?? ''),
                            ],
                          ),
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
