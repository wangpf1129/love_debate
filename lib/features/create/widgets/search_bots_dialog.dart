import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:love_debate/providers/api_providers.dart';
import 'package:love_debate/widgets/primary_button.dart';

class SearchBotsDialog extends HookConsumerWidget {
  const SearchBotsDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final query = useState('');

    useEffect(() {
      void listener() {
        query.value = searchController.text;
      }

      searchController.addListener(listener);
      return () => searchController.removeListener(listener);
    }, [searchController]);

    final debouncedQuery =
        useDebounced(query.value, const Duration(milliseconds: 1500));

    final isTyping = query.value != debouncedQuery && query.value.isNotEmpty;

    final botsAsync = ref.watch(fetchBotsProvider(debouncedQuery ?? ''));

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7, // 限制最大高度
        ),
        child: Stack(clipBehavior: Clip.none, children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 16, 22, 0),
                child: Column(
                  children: [
                    const Text(
                      '搜索辩手',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '搜索辩手',
                          suffixIcon: query.value.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      size: 18, color: Colors.white70),
                                  onPressed: () {
                                    searchController.clear();
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),

                    // 显示打字中状态
                    if (isTyping)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text('正在搜索...',
                            style:
                                TextStyle(fontSize: 12, color: Colors.white70)),
                      ),

                    const SizedBox(height: 22),
                  ],
                ),
              ),

              // 列表区域 - 使用 Expanded 让它填充可用空间
              Expanded(
                child: botsAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF8a63a6),
                    ),
                  ),
                  error: (error, stack) => const Center(
                    child: Text('加载失败', style: TextStyle(color: Colors.red)),
                  ),
                  data: (bots) {
                    if (bots.isEmpty) {
                      return const Center(
                        child: Text('没有找到辩手',
                            style: TextStyle(color: Colors.white70)),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: bots.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  bots[index].botAvatar,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(bots[index].botName,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      Text(bots[index].botDescription,
                                          style: const TextStyle(fontSize: 12),
                                          overflow: TextOverflow.ellipsis),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              // 底部按钮 - 固定在底部
              Padding(
                padding: const EdgeInsets.all(22),
                child: PrimaryButton(
                  text: '确定',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
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
      ),
    );
  }
}
