import 'dart:math' as Math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:love_debate/features/detail/widgets/energy_progress_bar.dart';
import 'package:love_debate/features/detail/widgets/info_drawer.dart';
import 'package:love_debate/hooks/use_debate_colors.dart';
import 'package:love_debate/models/debate.dart';
import 'package:love_debate/models/enums.dart';
import 'package:love_debate/providers/api_providers.dart';
import 'package:love_debate/routers/app_route.gr.dart';
import 'package:love_debate/widgets/custom_app_bar.dart';
import 'package:lottie/lottie.dart';

class DebaterDetail {
  final Bot? bot;
  final String content;
  final DebateStandpoint standpoint;
  final int sort;
  final int energies;

  DebaterDetail({
    required this.bot,
    required this.content,
    required this.standpoint,
    required this.sort,
    required this.energies,
  });
}

class Energy {
  final int my;
  final int opponent;

  Energy({required this.my, required this.opponent});
}

@RoutePage()
class DetailPage extends HookConsumerWidget {
  final String debateId;
  const DetailPage({super.key, required this.debateId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debateDetailAsync =
        ref.watch(fetchDebateDetailProvider(debateId, keyname: 'detail_page'));

    // 使用useState管理当前回合和轮询状态
    final currentRound = useState(1);
    final isPolling = useState(false);
    final roundData = useState<DebateRound?>(null);
    final tempContent = useState<String?>(null);
    final isProcessing = useState(false);

    final energy = useState(Energy(my: 50, opponent: 50));
    // 添加一个状态用于跟踪当前显示鼓掌动画的裁判索引（-1表示没有裁判显示动画）
    final clappingJudgeIndex = useState<int>(-1);

    // 添加一个状态用于跟踪火焰动画的显示
    final showFlameEffect = useState(false);
    // 添加一个状态用于跟踪是否已点击气势按钮
    final hasClickedAura = useState(false);

    // 添加一个状态用于记录点击气势时的回合数
    final auraClickedRound = useState<int>(-1);

    // 计算下一回合
    int getNextRound(int current, int maxRound) {
      return current < maxRound ? current + 1 : maxRound;
    }

    final currentDebater = useMemoized(() {
      if (debateDetailAsync.value == null || roundData.value == null) {
        return null;
      }

      return (
        bot: roundData.value!.bot,
        content: roundData.value!.content,
        standpoint: roundData.value!.standpoint,
        sort: roundData.value!.bot.sort,
        energies: roundData.value?.energies ?? 50,
      );
    }, [debateDetailAsync.value, roundData.value]);

    // 修改函数来根据概率更新鼓掌的裁判，但增加辩论状态检查
    void updateClappingJudge(int judgesCount) {
      // 只有在实际有辩论内容时才考虑显示鼓掌动画
      if (roundData.value != null && roundData.value!.content.isNotEmpty) {
        // 70%的概率触发鼓掌
        if (Math.Random().nextDouble() < 0.7 && judgesCount > 0) {
          // 随机选择一个裁判
          clappingJudgeIndex.value = Math.Random().nextInt(judgesCount);
        } else {
          clappingJudgeIndex.value = -1; // 不显示鼓掌动画
        }
      } else {
        // 没有辩论内容时，不显示鼓掌
        clappingJudgeIndex.value = -1;
      }
    }

    // 当回合变化时触发鼓掌逻辑
    useEffect(() {
      if (debateDetailAsync.value != null &&
          currentRound.value > 1 &&
          debateDetailAsync.value!.state == DebateState.fighting) {
        // 只有当回合大于1且有辩论数据时，才计算是否显示鼓掌
        if (roundData.value != null && roundData.value!.content.isNotEmpty) {
          updateClappingJudge(debateDetailAsync.value!.judges.length);
        }
      }
      return null;
    }, [currentRound.value, roundData.value]);

    // 当clappingJudgeIndex变化时，处理动画显示逻辑
    useEffect(() {
      if (clappingJudgeIndex.value >= 0) {
        // 3秒后重置索引，隐藏动画
        Future.delayed(const Duration(seconds: 3), () {
          if (context.mounted) {
            clappingJudgeIndex.value = -1;
          }
        });
      }
      return null;
    }, [clappingJudgeIndex.value]);

    // 使用Lottie替换原有的鼓掌动画小部件
    Widget buildClappingAnimation() {
      return SizedBox(
        height: 30,
        width: 30,
        child: Lottie.asset(
          'assets/animations/clapping.json',
          repeat: true,
          animate: true,
          fit: BoxFit.contain,
        ),
      );
    }

    // 处理气势按钮点击
    void handleAuraClick() async {
      // 状态判断
      if (debateDetailAsync.value?.state != DebateState.fighting) {
        Fluttertoast.showToast(msg: "该状态无法使用气势");
        return;
      }

      if (hasClickedAura.value) {
        Fluttertoast.showToast(msg: "本场辩论已使用过气势");
        return;
      }

      final isLastRound = currentRound.value >= 8;
      if (isLastRound) {
        Fluttertoast.showToast(msg: "最后一回合无法使用气势");
        return;
      }

      try {
        await ref.read(getAuraProvider(debateId).future);
        hasClickedAura.value = true;
        // 记录点击气势时的回合数
        auraClickedRound.value = currentRound.value;
        Fluttertoast.showToast(msg: "气势将在下一回合生效");
      } catch (error) {
        Fluttertoast.showToast(msg: error.toString());
      }
    }

    // 修改轮询效果，添加火焰动画的控制
    useEffect(() {
      // 只在点击气势的下一回合显示火焰动画
      if (hasClickedAura.value &&
          !showFlameEffect.value &&
          currentRound.value == auraClickedRound.value + 1) {
        showFlameEffect.value = true;

        // 一回合后关闭火焰动画
        Future.delayed(const Duration(seconds: 3), () {
          if (context.mounted) {
            showFlameEffect.value = false;
          }
        });
      }
      return null;
    }, [currentRound.value, hasClickedAura.value]);

    // 修改火焰动画组件，根据状态显示
    Widget buildFlameAnimation() {
      if (!showFlameEffect.value) return const SizedBox();

      return SizedBox(
        height: 24,
        child: Lottie.asset(
          'assets/animations/flame.json',
          repeat: true,
          animate: true,
          fit: BoxFit.contain,
        ),
      );
    }

    useEffect(() {
      if (debateDetailAsync.value != null && !isPolling.value) {
        isPolling.value = true;
        final detail = debateDetailAsync.value!;
        currentRound.value = detail.rounds;

        if (currentRound.value <= 8) {
          int nextRound = getNextRound(currentRound.value, 8);

          // 创建一个标志来跟踪组件是否已销毁
          bool isDisposed = false;

          startPolling() async {
            // 如果组件已销毁，不继续轮询
            if (isDisposed) return;

            try {
              final roundDetailAsync = await ref.read(
                  fetchDebateRoundProvider(debateId: debateId, round: nextRound)
                      .future);

              // 再次检查组件是否已销毁
              if (isDisposed) return;

              if (roundDetailAsync == null) {
                tempContent.value = "正在思考中...";
                isProcessing.value = true;
                Future.delayed(const Duration(seconds: 2), startPolling);
                return;
              }

              // 更新能量值
              if (roundData.value != null) {
                final myStandpoint = debateDetailAsync.value?.my.standpoint;
                final currentStandpoint = roundData.value!.standpoint;
                final currentEnergies = roundData.value!.energies;

                if (myStandpoint != null) {
                  final newMyEnergy = myStandpoint == currentStandpoint
                      ? currentEnergies
                      : (100 - currentEnergies);

                  if (energy.value.my != newMyEnergy) {
                    energy.value = Energy(
                      my: newMyEnergy,
                      opponent: 100 - newMyEnergy,
                    );
                  }
                }
              }

              // 正常情况，更新回合数据
              roundData.value = roundDetailAsync;
              tempContent.value = null; // 清除临时内容
              isProcessing.value = false; // 清除处理中状态

              // 检查所有三个条件：state为fighting、回合数小于8、content非空
              final bool isFighting =
                  debateDetailAsync.value?.state == DebateState.fighting;
              final bool hasContent = roundDetailAsync.content.isNotEmpty;
              final bool notMaxRounds = nextRound < 8;

              if (isFighting && hasContent) {
                currentRound.value = nextRound;
                if (notMaxRounds) {
                  nextRound = getNextRound(nextRound, 8);
                  final contentLength = roundDetailAsync.content.length;
                  int delay = 5000;
                  delay +=
                      Math.min(10000, (contentLength / 100).floor() * 2000);

                  // 延迟前检查组件是否已销毁
                  if (!isDisposed) {
                    Future.delayed(Duration(milliseconds: delay), startPolling);
                  }
                } else {
                  // 达到最大回合，停止轮询
                  isPolling.value = false;

                  // 刷新辩论详情并等待新状态
                  final refreshedDetail = await ref.refresh(
                      fetchDebateDetailProvider(debateId,
                              keyname: 'detail_page')
                          .future);
                  // 如果状态已更新为已完成，停止轮询
                  if (refreshedDetail.state == DebateState.finished ||
                      refreshedDetail.state == DebateState.grading) {
                    isPolling.value = false;
                  }
                }
              } else if (isFighting && notMaxRounds) {
                if (!isDisposed) {
                  Future.delayed(const Duration(seconds: 2), startPolling);
                }
              } else {
                // 战斗已结束或达到最大回合数，停止轮询
                isPolling.value = false;

                // 获取并使用刷新后的状态
                final refreshedDetail = await ref.refresh(
                    fetchDebateDetailProvider(debateId, keyname: 'detail_page')
                        .future);
                if (refreshedDetail.state == DebateState.finished ||
                    refreshedDetail.state == DebateState.grading) {
                  // 可以在这里处理辩论结束的逻辑
                  isPolling.value = false;
                }
              }
            } catch (e) {
              print('轮询错误: $e');
              if (!isDisposed) {
                Future.delayed(const Duration(seconds: 3), startPolling);
              }
            }
          }

          startPolling();

          // 清理函数
          return () {
            isDisposed = true; // 标记组件已销毁
            isPolling.value = false;
          };
        }
      }

      return () {
        isPolling.value = false;
      };
    }, [debateDetailAsync.value]);

    handleEscapeDebate() {
      // 二次确认弹窗，点击确认就调逃跑接口
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('确认逃跑'),
          content: const Text('确定要退出当前辩论吗？'),
          actions: [
            TextButton(
              onPressed: () async {
                // 停止轮询
                isPolling.value = false;
                try {
                  await ref.read(escapeDebateProvider(debateId).future);
                  print('逃跑成功');

                  if (context.mounted) {
                    // 逃跑成功后就返回首页
                    context.router
                        .popUntil(ModalRoute.withName(ListRoute.name));
                  }
                } catch (error) {
                  Fluttertoast.showToast(msg: error.toString());
                }
              },
              child: const Text('确认'),
            ),
            TextButton(
              onPressed: () {
                context.router.pop();
              },
              child: const Text('取消'),
            ),
          ],
        ),
      );
    }

    return debateDetailAsync.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF8A63A6),
          ),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        appBar: CustomAppBar(onBackPressed: () {
          context.router.pop();
        }),
        body: Center(
          child: Text(
            '加载失败: $error',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      data: (debateDetail) {
        final opponentColors =
            useDebateColors(debateDetail.opponent.standpoint);
        final myColors = useDebateColors(debateDetail.my.standpoint);
        final currentDebaterColors = useDebateColors(
            currentDebater?.standpoint ?? DebateStandpoint.pros);

        return Scaffold(
          appBar: CustomAppBar(onBackPressed: () {
            context.router.popUntil(ModalRoute.withName(ListRoute.name));
          }),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // 对方辩手
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  decoration: BoxDecoration(
                    color: opponentColors.backgroundColor,
                    border: Border(
                      bottom: BorderSide(
                        color: opponentColors.borderColor,
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
                              debateDetail.opponent.bots.length,
                              (index) => Stack(
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 24),
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF1A121F),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              color: opponentColors.mainColor,
                                              width: 1.5),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: Image.network(
                                            debateDetail
                                                .opponent.bots[index].botAvatar,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Icon(Icons.person,
                                                  color:
                                                      opponentColors.mainColor);
                                            },
                                          ),
                                        ),
                                      ),
                                      if (currentDebater?.bot.botId ==
                                          debateDetail
                                              .opponent.bots[index].botId)
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          child: Container(
                                            width: 44,
                                            height: 44,
                                            color: opponentColors.mainColor
                                                .withOpacity(0.5),
                                            child: const Icon(Icons.more_horiz,
                                                color: Colors.black),
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
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            borderRadius:
                                                const BorderRadius.only(
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
                                  color: opponentColors.mainColor,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  opponentColors.label,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 100, // 设置固定的宽度
                                child: Text(
                                  debateDetail.opponent.nickname,
                                  style: const TextStyle(
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '第${currentRound.value}回合',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '总：${currentRound.value}/8回合',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF8A63A6),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 双方气势进度条
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 24),
                        child: Column(
                          children: [
                            // 原有的进度条
                            Stack(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${myColors.label}气势',
                                      style: const TextStyle(
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
                                            myEnergy: energy.value.my / 100,
                                            opponentEnergy:
                                                energy.value.opponent / 100,
                                            myColor: myColors.mainColor,
                                            opponentColor:
                                                opponentColors.mainColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${opponentColors.label}气势',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  left: 10,
                                  bottom: 0,
                                  child: buildFlameAnimation(),
                                ),
                                Positioned(
                                  right: 10,
                                  bottom: 0,
                                  child: buildFlameAnimation(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        currentDebater != null
                            ? Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: currentDebaterColors.mainColor,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.network(
                                          currentDebater.bot.botAvatar,
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: currentDebaterColors.mainColor,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Text(
                                          '${currentDebaterColors.label} ${currentDebater.sort}辩',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          currentDebater.bot.botName,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            : const SizedBox(),
                        // row 方向的头像列表 3个
                        Row(
                          children: List.generate(
                            debateDetail.judges.length,
                            (index) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Stack(
                                clipBehavior: Clip.none, // 确保不会被裁剪
                                children: [
                                  // 裁判头像容器
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: Colors.white.withOpacity(0.2),
                                          width: 2),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.network(
                                        debateDetail.judges[index].botAvatar,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),

                                  // 裁判鼓掌动画，使用Lottie
                                  if (clappingJudgeIndex.value == index)
                                    Positioned(
                                      top: -12, // 进一步调高位置以适应Lottie动画
                                      left: -12, // 进一步调左位置
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: buildClappingAnimation(),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),

                // 使用组合数据
                if (currentDebater != null) ...[
                  // 显示组合数据中的内容
                  Container(
                    margin: const EdgeInsets.only(top: 22, left: 16, right: 16),
                    padding: const EdgeInsets.only(
                        top: 20, left: 20, right: 14, bottom: 22),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFF2B252D),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isProcessing.value) // 处理"发言中"状态
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tempContent.value ?? "正在思考中...",
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "💡 对方正在组织语言，请稍候",
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          )
                        else if (roundData.value != null) // 正常内容
                          Text(
                            roundData.value!.content,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          )
                        else // 等待开始
                          const Text(
                            "等待辩论开始...",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                  ),
                ] else if (isPolling.value) ...[
                  // 显示加载指示器
                  const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF8A63A6),
                    ),
                  ),
                ] else ...[
                  // 显示默认信息
                  Container(
                    margin: const EdgeInsets.only(top: 22, left: 16, right: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFF2B252D),
                    ),
                    child: const Text(
                      '等待辩论开始...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],

                const SizedBox(height: 20),
                if (debateDetail.state == DebateState.finished ||
                    debateDetail.state == DebateState.grading)
                  ElevatedButton(
                    onPressed: () {
                      context.router.push(ResultRoute(debateId: debateId));
                    },
                    child: const Text('查看结果'),
                  ),

                InfoDrawer(
                  title: debateDetail.themeTitle,
                  standpointText: debateDetail.my.standpointView,
                  onEscapeButtonTapped: handleEscapeDebate,
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(vertical: 22),
            decoration: BoxDecoration(
              color: myColors.backgroundColor,
              border: Border(
                top: BorderSide(
                  color: myColors.borderColor,
                  width: 2,
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...List.generate(
                      debateDetail.my.bots.length,
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
                                color: myColors.mainColor,
                                width: 1.5,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.network(
                                debateDetail.my.bots[index].botAvatar,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.person,
                                      color: Color(0xFF8A63A6));
                                },
                              ),
                            ),
                          ),
                          if (currentDebater?.bot.botId ==
                              debateDetail.my.bots[index].botId)
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                width: 44,
                                height: 44,
                                color: myColors.mainColor.withOpacity(0.5),
                                child: const Icon(Icons.more_horiz,
                                    color: Colors.black),
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
                      ),
                    ),
                    ElevatedButton(
                      onPressed: handleAuraClick,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: myColors.mainColor,
                        // 根据状态设置不同的透明度
                        foregroundColor: Colors.white.withOpacity(
                          0.5,
                        ),
                      ),
                      child: const Text(
                        '💪 气势',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
