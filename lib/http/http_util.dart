import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/cupertino.dart';

import 'api.dart';

class HttpUtil {
  Dio? _dio;
  static HttpUtil? _instance;
  final CancelToken _cancelToken = CancelToken();

  factory HttpUtil.getInstance() {
    return _instance ??= HttpUtil._internal();
  }

  HttpUtil._internal() {
    BaseOptions options = BaseOptions(
        baseUrl: Api.baseUrl,
        connectTimeout: const Duration(seconds: 5),
        sendTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        headers: {"version": "1.0.0"},
        //请求的Content-Type，默认值是"application/json; charset=utf-8",Headers.formUrlEncodedContentType会自动编码请求体.
        contentType: Headers.formUrlEncodedContentType,
        //表示期望以那种格式(方式)接受响应数据。接受四种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
        responseType: ResponseType.json);

    _dio = Dio(options);
    //Cookie管理 // First request, and save cookies (CookieManager do it)
    final cookieJar = CookieJar();
    _dio?.interceptors.add(CookieManager(cookieJar));
    // 添加请求拦截器
    _dio?.interceptors.add(InterceptorsWrapper(onRequest: (
      RequestOptions options,
      RequestInterceptorHandler handler,
    ) {
      debugPrint("请求之前 header = ${options.headers.toString()}");
      // 如果你想完成请求并返回一些自定义数据，你可以使用 `handler.resolve(response)`。
      // 如果你想终止请求并触发一个错误，你可以使用 `handler.reject(error)`。
      return handler.next(options);
    }, onResponse: (
      Response<dynamic> response,
      ResponseInterceptorHandler handler,
    ) {
      debugPrint("响应之前");
      // 如果你想完成请求并返回一些自定义数据，你可以使用 `handler.resolve(response)`。
      return handler.next(response);
    }, onError: (
      DioException e,
      ErrorInterceptorHandler handler,
    ) {
      debugPrint("错误之前");
      // 如果你想终止请求并触发一个错误，你可以使用 `handler.reject(error)`。
      return handler.next(e);
    }));
  }

  /// get请求
  get(url, {params, method = "get", cancelToken}) async {
    Response? response;
    try {
      Options options = Options(method: method);
      response = await _dio?.request(url,
          queryParameters: params, cancelToken: cancelToken, options: options);
    } on DioException catch (e) {
      formatError(e);
    }

    return response?.data;
  }

  /// post请求
  post(url, {params, method = "post", cancelToken}) async {
    Response? response;
    try {
      Options options = Options(method: method);
      response = await _dio?.post(url,
          queryParameters: params, cancelToken: cancelToken, options: options);
    } on DioException catch (e) {
      formatError(e);
    }

    return response?.data;
  }

  /// 下载文件
  download(requestUrl, savePath) async {
    Response? response;
    try {
      response = await _dio?.download(requestUrl, savePath,
          onReceiveProgress: (int count, int total) {
        debugPrint("文件下载进度，count :$count,total :$total");
      });
    } on DioException catch (e) {
      formatError(e);
    }

    return response?.data;
  }

  void cancelRequest(CancelToken token) {
    token.cancel("cancelled");
  }

  /// error统一处理
  void formatError(DioError e) {
    if (e.type == DioErrorType.connectionTimeout) {
      // It occurs when url is opened timeout.
      debugPrint("连接超时");
    } else if (e.type == DioErrorType.sendTimeout) {
      // It occurs when url is sent timeout.
      debugPrint("请求超时");
    } else if (e.type == DioErrorType.receiveTimeout) {
      //It occurs when receiving timeout
      debugPrint("响应超时");
    } else if (e.type == DioErrorType.badResponse) {
      // When the server response, but with a incorrect status, such as 404, 503...
      debugPrint("出现异常");
    } else if (e.type == DioErrorType.cancel) {
      // When the request is cancelled, dio will throw a error with this type.
      debugPrint("请求取消");
    } else {
      //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
      debugPrint("未知错误");
    }
  }
}
