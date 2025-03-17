// 对战记录列表
import 'package:love_debate/api/http_server.dart';
import 'package:love_debate/models/index.dart';
import 'dart:convert';

class BattleRecordListApi {
  static Future<List<DebateRecord>> getBattleRecordList() async {
    try {
      final response = await HttpServer().get('/fight');

      // 确保 response.data 是 Map
      final Map<String, dynamic> responseData =
          response.data is String ? jsonDecode(response.data) : response.data;

      // 使用 ListResponse 解析响应
      final listResponse = ListResponse<DebateRecord>.fromJson(
        responseData,
        (json) => DebateRecord.fromJson(json as Map<String, dynamic>),
      );

      if (listResponse.code == 200) {
        return listResponse.data;
      } else {
        throw Exception(listResponse.info);
      }
    } catch (e) {
      rethrow;
    }
  }
}
