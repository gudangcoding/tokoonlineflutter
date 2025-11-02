import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final Dio dio;
  final SharedPreferences prefs;

  ApiClient(this.dio, this.prefs) {
    final token = prefs.getString('token');
    if (token != null && token.isNotEmpty) {
      setToken(token);
    }
  }

  void setToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
    prefs.setString('token', token);
  }

  void clearToken() {
    dio.options.headers.remove('Authorization');
    prefs.remove('token');
  }

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? query}) {
    return dio.get<T>(path, queryParameters: query);
  }

  Future<Response<T>> post<T>(String path, {dynamic data}) {
    return dio.post<T>(path, data: data);
  }

  Future<Response<T>> put<T>(String path, {dynamic data}) {
    return dio.put<T>(path, data: data);
  }

  Future<Response<T>> delete<T>(String path, {dynamic data}) {
    return dio.delete<T>(path, data: data);
  }
}