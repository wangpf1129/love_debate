import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:love_debate/widgets/primary_button.dart';

class StrategyDialog extends HookWidget {
  final String? initialStrategy;
  final Function(String) onStrategyChanged;

  const StrategyDialog(
      {super.key,
      required this.initialStrategy,
      required this.onStrategyChanged});

  @override
  Widget build(BuildContext context) {
    final textController =
        useTextEditingController(text: initialStrategy ?? "");
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(clipBehavior: Clip.none, children: [
        Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '设置辩论策略（进阶）',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 22,
              ),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                    // 底部有白色边框给移除掉
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  )),
              const SizedBox(
                height: 22,
              ),
              PrimaryButton(
                text: '确定',
                onPressed: () {
                  if (textController.text.isEmpty) {
                    // toast
                    Fluttertoast.showToast(
                      msg: '请输入辩论策略',
                      gravity: ToastGravity.CENTER,
                    );
                    return;
                  }
                  onStrategyChanged(textController.text);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
        // 右上角关闭按钮
        Positioned(
          top: 10,
          right: 10,
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
