import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:love_debate/features/create/widgets/search_bots_dialog.dart';
import 'package:love_debate/features/create/widgets/strategy_dialog.dart';
import 'package:love_debate/models/debate.dart';
import 'package:love_debate/models/enums.dart';
import 'package:love_debate/providers/api_providers.dart';
import 'package:love_debate/routers/app_route.gr.dart';
import 'package:love_debate/widgets/custom_app_bar.dart';
import 'package:love_debate/widgets/primary_button.dart';

@RoutePage()
class CreatePage extends HookConsumerWidget {
  final String debateId;
  const CreatePage({super.key, required this.debateId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debateDetailAsync =
        ref.watch(fetchDebateDetailProvider(debateId, keyname: 'create_page'));

    final strategyState = useState('');
    final selectedBots = useState<List<Bot>>(List.filled(4, Bot.empty()));
    final selectedIndex = useState<int?>(-1);

    bool hasBotAt(int index) {
      return index < selectedBots.value.length &&
          selectedBots.value[index].botId != '';
    }

    void showStrategyDialog(
        BuildContext context, ValueNotifier<String> strategyState) {
      showDialog(
        context: context,
        builder: (context) {
          return StrategyDialog(
            initialStrategy: strategyState.value,
            onStrategyChanged: (strategy) {
              strategyState.value = strategy;
            },
          );
        },
      );
    }

    void showSearchBotsDialog(BuildContext context, int position) {
      if (position < 0 || position >= 4) {
        // 表示没有位置可以添加辩手, 如果有空位置，默认添加到第一个空位置
        position = selectedBots.value.indexWhere((bot) => bot.botId == '') != -1
            ? selectedBots.value.indexWhere((bot) => bot.botId == '')
            : 0;
      }

      showDialog(
        context: context,
        builder: (context) {
          return SearchBotsDialog(
            onBotSelected: (bot) {
              final newBots = List<Bot>.from(selectedBots.value);
              newBots[position] = bot;
              selectedBots.value = newBots;
              selectedIndex.value = -1;
            },
          );
        },
      );
    }

    void handleBoxTap(BuildContext context, int index) {
      if (hasBotAt(index)) {
        if (selectedIndex.value == index) {
          selectedIndex.value = -1;
        } else {
          selectedIndex.value = index;
        }
      } else {
        showSearchBotsDialog(context, index);
      }
    }

    void removeBot(int index) {
      final newBots = List<Bot>.from(selectedBots.value);
      newBots[index] = Bot.empty();
      selectedBots.value = newBots;
      selectedIndex.value = -1;
    }

    final pendingCreateDebate = useState<Future<void>?>(null);
    final createDebateSnapshot = useFuture(pendingCreateDebate.value);
    handleCreateButtonTapped() {
      if (selectedBots.value.where((bot) => bot.botId != '').length < 4) {
        Fluttertoast.showToast(msg: '请选择至少4个辩手');
        return;
      }
      final payload = CreatePayload(
        bots: selectedBots.value.asMap().entries.map((entry) {
          final index = entry.key; // 获取位置索引 (0-3)
          final bot = entry.value;
          return BotPayload(
            botId: bot.botId,
            botName: bot.botName,
            sort: index + 1, // 将位置索引+1作为sort值传给接口
          );
        }).toList(),
        tactics: strategyState.value,
      );

      pendingCreateDebate.value = ref
          .read(createDebateProvider(debateId, payload).future)
          .then((value) {
        if (context.mounted) {
          Fluttertoast.showToast(msg: '创建成功');
          context.router.replace(DetailRoute(debateId: debateId));
        }
      }).catchError((error) {
        Fluttertoast.showToast(msg: error.toString());
        throw error; // 重新抛出错误以更新 snapshot 状态
      });
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(onBackPressed: () {
        context.router.popUntil(ModalRoute.withName(ListRoute.name));
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
                    Text(
                      debateDetailAsync.when(
                          data: (debateDetail) => debateDetail.themeTitle,
                          error: (error, stack) => '加载失败',
                          loading: () => '加载中'),
                      style: const TextStyle(
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
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                      child: Text(
                        debateDetailAsync.when(
                            data: (debateDetail) =>
                                debateDetail.my.standpoint ==
                                        DebateStandpoint.pros
                                    ? '正方'
                                    : '反方',
                            error: (error, stack) => '加载失败',
                            loading: () => '加载中'),
                        style: const TextStyle(
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
                    Flexible(
                        child: Text(
                      debateDetailAsync.when(
                          data: (debateDetail) =>
                              debateDetail.my.standpointView,
                          error: (error, stack) => '加载失败',
                          loading: () => '加载中'),
                      style: const TextStyle(
                        color: Color(0xFF9261A9),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Container(
                width: MediaQuery.of(context).size.width * 0.96,
                height: 300,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/create_modal_bg.png'),
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 10, top: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(color: Colors.white),
                              children: [
                                const TextSpan(
                                  text: '选择你的辩手',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      '（${selectedBots.value.where((bot) => bot.botId != '').length}/4）',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              showSearchBotsDialog(context, -1);
                            },
                            icon: const Icon(
                              Icons.add_circle_outline,
                              color: Color(0xFF9261A9),
                              size: 22,
                            ),
                          ),
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
                    Row(
                      spacing: 12,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        4,
                        (index) {
                          final hasBot = hasBotAt(index);
                          final isSelected = selectedIndex.value == index;

                          return GestureDetector(
                            onTap: () => handleBoxTap(context, index),
                            child: Stack(
                              children: [
                                Container(
                                  width: 69,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1A121F),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF9261A9) // 选中时紫色边框
                                          : Colors.white
                                              .withAlpha(20), // 未选中时浅色边框
                                      width: isSelected ? 2 : 1,
                                    ),
                                  ),
                                  child: hasBot
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            selectedBots.value[index].botAvatar,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stack) {
                                              return Container(
                                                color: Colors.grey.shade800,
                                                child: const Icon(Icons.person,
                                                    size: 24,
                                                    color: Colors.white),
                                              );
                                            },
                                          ),
                                        )
                                      : const Center(
                                          child: Icon(
                                            Icons.add_circle_outline,
                                            color: Color(0xFF9261A9),
                                            size: 24,
                                          ),
                                        ),
                                ),
                                Positioned(
                                  top: 4,
                                  left: 4,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                if (isSelected && hasBot)
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () => removeBot(index),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.black45,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
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
                        padding: const EdgeInsets.all(2),
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
                              showStrategyDialog(context, strategyState);
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
                  loading: createDebateSnapshot.connectionState ==
                      ConnectionState.waiting,
                  onPressed: () => handleCreateButtonTapped()),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              transform: Matrix4.translationValues(
                  0,
                  MediaQuery.of(context).viewInsets.bottom > 0
                      ? -MediaQuery.of(context).viewInsets.bottom
                      : 0,
                  0),
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
                            debateDetailAsync.when(
                                data: (debateDetail) =>
                                    debateDetail.judges.length,
                                error: (error, stack) => 0,
                                loading: () => 0),
                            (index) {
                              final judge = debateDetailAsync.when(
                                  data: (debateDetail) =>
                                      debateDetail.judges[index],
                                  error: (error, stack) => null,
                                  loading: () => null);
                              return SizedBox(
                                width: 100,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        judge?.botAvatar ?? '',
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stack) {
                                          return Container(
                                            width: 50,
                                            height: 50,
                                            color: Colors.grey.shade800,
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      judge?.botName ?? '',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
