import 'package:flutter/material.dart';
import 'package:love_debate/widgets/primary_button.dart';

class StrategyDialog extends StatefulWidget {
  final String? initialStrategy;
  final Function(String) onStrategyChanged;

  const StrategyDialog(
      {super.key,
      required this.initialStrategy,
      required this.onStrategyChanged});

  @override
  State<StrategyDialog> createState() => _StrategyDialogState();
}

class _StrategyDialogState extends State<StrategyDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialStrategy ?? '');

    _controller.addListener(() {
      widget.onStrategyChanged(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    controller: _controller,
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                    // 底部有白色边框给移除掉
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  )),
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
        Positioned(
          bottom: -80,
          left: 0,
          right: 0,
          child: PrimaryButton(text: '确定', onPressed: () {}),
        )
      ]),
    );
  }
}
