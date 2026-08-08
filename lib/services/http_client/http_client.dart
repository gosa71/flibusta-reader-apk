import 'package:dio/dio.dart';

class ProxyHttpClient {
  static final ProxyHttpClient _instance = ProxyHttpClient._internal();
  factory ProxyHttpClient() => _instance;
  ProxyHttpClient._internal();

  Dio _dio = Dio(BaseOptions(
    connectTimeout: 15000,
    receiveTimeout: 30000,
    baseUrl: 'http://flibusta.is',
  ));

  Dio get dio => _dio;

  Future<String> getHtml(String path) async {
    final response = await _dio.get(path);
    return response.data.toString();
  }

  void setProxy(String proxy) {
    // TODO apply proxy
  }

  void clearProxy() {}

  void setHostAddress(String url) {
    _dio.options.baseUrl = url ?? 'http://flibusta.is';
  }

  Future<void> initCookieJar() async {}
}
