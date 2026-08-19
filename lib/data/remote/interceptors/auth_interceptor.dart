import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  String? _token;

  void setToken(String token) {
    _token = token;
  }

  void clearToken() {
    _token = null;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_token != null) {
      options.headers['Authorization'] = 'Bearer $_token';
    }
    handler.next(options);
  }
}
