import 'package:dio/dio.dart';
import 'dart:convert'; // 添加这个导入

class HttpServer {
  late Dio _dio;

  static final HttpServer _singleton = HttpServer._instance();
  factory HttpServer() {
    return _singleton;
  }

  HttpServer._instance() {
    _dio = Dio(BaseOptions(
      baseUrl: "https://newapi.mbd.pub/release/debate",
      connectTimeout: const Duration(seconds: 3),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // // 添加日志拦截器
    // _dio.interceptors.add(PrettyDioLogger(
    //     requestHeader: true, // 请求头
    //     requestBody: true, // 请求体
    //     responseBody: true, // 响应体
    //     responseHeader: false, // 响应头
    //     compact: false)); // 是否压缩

    // 添加自定义拦截器
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        const token =
            "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjozMSwiZXhwIjoxNzQzODM4MjI1fQ.qW4kmUN93zHJhACAPqsm7zEzsE-tOQapSAqdcU5ZERg";
        options.headers['Authorization'] = token;
        return handler.next(options);
      },
      onResponse: (response, handler) {
        try {
          // 确保我们有响应数据
          if (response.data == null) {
            return handler.reject(
              DioException(
                requestOptions: response.requestOptions,
                error: "响应数据为空",
              ),
            );
          }
          // 将字符串解析为 Map
          final Map<String, dynamic> responseData = response.data is String
              ? jsonDecode(response.data)
              : response.data;

          final code = responseData['code'] as int;
          final info = responseData['info'] as String;

          if (code >= 200 && code < 300) {
            return handler.next(response);
          } else {
            return handler.reject(
              DioException(
                requestOptions: response.requestOptions,
                error: BusinessException(
                  code: code,
                  message: info,
                ),
              ),
            );
          }
        } catch (e) {
          return handler.reject(
            DioException(
              requestOptions: response.requestOptions,
              error: "响应处理错误: ${e.toString()}",
            ),
          );
        }
      },
      onError: (DioException error, handler) {
        return handler.next(error);
      },
    ));
  }
  // 获取dio实例
  Dio get dioInstance => _dio;

  // 封装请求方法
  Future<Map<String, dynamic>> _request(
    String path,
    String method, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      late Response response;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await _dio.get(
            path,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
            onReceiveProgress: onReceiveProgress,
          );
          break;
        case 'POST':
          response = await _dio.post(
            path,
            data: data,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
          );
          break;
        case 'PATCH':
          response = await _dio.patch(
            path,
            data: data,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
          );
          break;
        case 'PUT':
          response = await _dio.put(
            path,
            data: data,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
          );
          break;
        case 'DELETE':
          response = await _dio.delete(
            path,
            data: data,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
          );
          break;
        default:
          throw Exception('Unsupported method: $method');
      }

      // 统一处理响应数据转换
      return response.data is String
          ? jsonDecode(response.data)
          : response.data;
    } on DioException catch (error) {
      throw _handleError(error);
    }
  }

  // 对外暴露的方法都变得非常简洁
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _request(
      path,
      'GET',
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Map<String, dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _request(
      path,
      'POST',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  // patch
  Future<Map<String, dynamic>> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _request(
      path,
      'PATCH',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Map<String, dynamic>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _request(
      path,
      'PUT',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Map<String, dynamic>> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _request(
      path,
      'DELETE',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Exception _handleError(dynamic error) {
    if (error is DioException) {
      if (error.error is BusinessException) {
        // 业务错误，直接返回
        return error.error as BusinessException;
      }

      // 处理其他 Dio 错误
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return Exception("网络请求超时，请稍后再试");
        case DioExceptionType.connectionError:
          return Exception("网络连接错误，请检查网络状态");
        default:
          return Exception(error.error?.toString() ?? "未知错误");
      }
    }
    return Exception("未知错误");
  }
}

class BusinessException implements Exception {
  final int code;
  final String message;

  BusinessException({required this.code, required this.message});

  @override
  String toString() => message;
}
