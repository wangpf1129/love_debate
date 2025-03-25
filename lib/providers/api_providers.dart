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

// 匹配
@riverpod
Future<MatchDebate> matchDebate(Ref ref) async {
  final response = await HttpServer().get('/match');
  return BaseResponse.fromJson(response,
      (json) => MatchDebate.fromJson(json as Map<String, dynamic>)).data;
}

// ai搜索列表
@riverpod
Future<List<Bot>> fetchBots(Ref ref, String? keyword) async {
  final response = await HttpServer().get('/bots/search?keyword=$keyword');

  return ListResponse<Bot>.fromJson(
    response,
    (json) => Bot.fromJson(json as Map<String, dynamic>),
  ).data;
}

// 提交辩论
@riverpod
Future<dynamic> createDebate(
    Ref ref, String debateId, CreatePayload payload) async {
  final response = await HttpServer().post('/$debateId/prepare', data: payload);
  return BaseResponse.fromJson(response, (json) => json).data;
}

// 获取辩论详情
@riverpod
Future<DebateItem> fetchDebateDetail(Ref ref, String debateId) async {
  final response = await HttpServer().get('/fight/$debateId');
  return BaseResponse.fromJson(
          response, (json) => DebateItem.fromJson(json as Map<String, dynamic>))
      .data;
}

// 获取辩论回合的详情
@riverpod
Future<DebateRound?> fetchDebateRound(
  Ref ref, {
  required String debateId,
  required int round,
}) async {
  try {
    final response = await HttpServer().get('/fight/$debateId/deliver/$round');

    // 检查特殊情况：code=200 且 data=null
    if (response['code'] == 200 && response['data'] == null) {
      return null;
    }

    // 正常情况：解析数据
    final baseResponse = BaseResponse.fromJson(
        response,
        (json) => json == null
            ? null
            : DebateRound.fromJson(json as Map<String, dynamic>));

    return baseResponse.data;
  } catch (e) {
    return null;
  }
}
