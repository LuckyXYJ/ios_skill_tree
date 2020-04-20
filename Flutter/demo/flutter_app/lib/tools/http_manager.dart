import 'package:dio/dio.dart';

class HttpManager {
  static final Dio dio = Dio();

  static Future request(String url,
      {String method = 'get',
        Map<String, dynamic>? queryParameters,
        required int receiveTimeout}) {
    //1.创建配置确定是走什么请求方式
    final options = Options(method: method, receiveTimeout: receiveTimeout);
    //2.发送网络请求
    return dio.request(url, queryParameters: queryParameters, options: options);
  }
}

Future get(url, {Map<String, dynamic>? queryParameters, int timeOut = 6000}) {
  return HttpManager.request(url,
      queryParameters: queryParameters, method: 'get', receiveTimeout: timeOut);
}