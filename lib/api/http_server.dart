import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

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

    // 添加日志拦截器
    _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true, // 请求头
        requestBody: true, // 请求体
        responseBody: true, // 响应体
        responseHeader: false, // 响应头
        compact: false)); // 是否压缩

    // 添加自定义拦截器
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        const token =
            "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjozMSwiZXhwIjoxNzQzODM4MjI1fQ.qW4kmUN93zHJhACAPqsm7zEzsE-tOQapSAqdcU5ZERg";
        options.headers['Authorization'] = token;
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException error, handler) {
        return handler.next(error);
      },
    ));
  }
  // 获取dio实例
  Dio get dioInstance => _dio;

  // GET请求
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get(path,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress);
      return response;
    } on DioException catch (error) {
      throw _handleError(error);
    }
  }

  //POST请求
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // PUT请求
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE请求
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    String errorMessage = "发生错误，请稍后再试";

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          errorMessage = "网络请求超时，请稍后再试";
          break;
        case DioExceptionType.badResponse:
          errorMessage = _handleResponseError(error.response);
          break;
        case DioExceptionType.connectionError:
          errorMessage = "网络连接错误，请检查网络状态";
          break;
        default:
          errorMessage = "未知错误，请稍后再试";
      }
    }
    return DioException(
      requestOptions: error.requestOptions,
      error: errorMessage,
    );
  }

// 处理错误响应
  String _handleResponseError(Response? response) {
    String errorMessage = "发生错误，请稍后再试";

    if (response != null) {
      try {
        if (response.data != null && response.data is Map) {
          errorMessage = response.data['message'] ?? errorMessage;
        }
      } catch (e) {
        errorMessage = "响应解析错误";
      }
    }

    return errorMessage;
  }
}
