// 对战记录列表

import 'package:love_debate/api/http_server.dart';
import 'package:love_debate/models/index.dart';

class ApiServer {
  static Future<ListResponse<DebateRecord>> getBattleRecordList() async {
    try {
      final response = await HttpServer().get('/fight');

      // 直接返回 ListResponse
      return ListResponse<DebateRecord>.fromJson(
        response,
        (json) => DebateRecord.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      rethrow;
    }
  }
}
