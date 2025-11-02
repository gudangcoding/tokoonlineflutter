import 'package:dio/dio.dart';

class LoginResult {
  final String token;
  final String? customerId;
  LoginResult({required this.token, this.customerId});
}

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  Future<String> login(String email, String password) async {
    final result = await loginDetailed(email, password);
    return result.token;
  }

  Future<LoginResult> loginDetailed(String email, String password) async {
    // Endpoint disesuaikan dengan URL API: /api/customers/login
    final res = await dio.post('/customers/login', data: {
      'email': email,
      'password': password,
    });
    final data = res.data;
    String? token;
    String? customerId;
    if (data is Map<String, dynamic>) {
      // Coba beberapa kemungkinan nama field token dari backend
      token = (data['token'] ?? data['access_token']) ??
          (data['data'] is Map<String, dynamic> ? (data['data'] as Map<String, dynamic>)['token'] : null);

      // Coba beberapa kemungkinan lokasi id customer
      final candidate = [
        data['customer'],
        data['user'],
        data['data'],
      ];
      for (final c in candidate) {
        if (c is Map<String, dynamic>) {
          final id = c['id'] ?? c['customer_id'] ?? c['uuid'];
          if (id != null) {
            customerId = id.toString();
            break;
          }
        }
      }
      // Coba di root bila backend langsung mengirim id
      if (customerId == null && data['id'] != null) {
        customerId = data['id'].toString();
      }
    }
    if (token is String && token.isNotEmpty) {
      return LoginResult(token: token, customerId: customerId);
    }
    throw DioException(
      requestOptions: res.requestOptions,
      error: 'Token tidak ditemukan pada respons login',
    );
  }

  Future<String> register(String name, String email, String password) async {
    final res = await dio.post('/auth/register', data: {
      'name': name,
      'email': email,
      'password': password,
    });
    final data = res.data as Map<String, dynamic>;
    return data['token'] as String; // assume returns token after register
  }

  Future<void> logout() async {
    try {
      await dio.post('/auth/logout');
    } catch (_) {
      // ignore
    }
  }
}