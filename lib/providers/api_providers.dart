import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:love_debate/api/http_server.dart';
import 'package:love_debate/models/index.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_providers.g.dart';

@Riverpod(keepAlive: true)
Future<List<DebateRecord>> fetchDebateRecords(Ref ref) async {
  final response = await HttpServer().get('/fight');

  // 解析响应并直接返回数据
  final listResponse = ListResponse<DebateRecord>.fromJson(
    response,
    (json) => DebateRecord.fromJson(json as Map<String, dynamic>),
  );
  return listResponse.data;
}
