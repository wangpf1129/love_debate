import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class InfoDrawer extends HookWidget {
  // 标题和立场
  final String title;
  final String standpointText;
  const InfoDrawer({
    super.key,
    required this.title,
    required this.standpointText,
  });

  @override
  Widget build(BuildContext context) {
    final isDrawerExpanded = useState(false);
    return // 抽屉容器
        Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // 子弹头形状的把手
          GestureDetector(
            onTap: () {
              isDrawerExpanded.value = !isDrawerExpanded.value;
            },
            child: Container(
              width: 30,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  bottomLeft: Radius.circular(40),
                ),
              ),
              child: Center(
                child: Icon(
                  isDrawerExpanded.value
                      ? Icons.chevron_right
                      : Icons.chevron_left,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),

          // 可展开的抽屉主体
          ClipRect(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: isDrawerExpanded.value
                  ? MediaQuery.of(context).size.width - 52
                  : 0,
              height: 60,
              color: Colors.white.withOpacity(0.3),
              child: OverflowBox(
                maxWidth: MediaQuery.of(context).size.width - 52,
                minWidth: 0,
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 52,
                  child: isDrawerExpanded.value
                      ? Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '你的立场：$standpointText',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color(0xFF9261A9).withOpacity(0.1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  '逃跑',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                ),
              ),
            ),
          ),

          // 右侧边距
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
