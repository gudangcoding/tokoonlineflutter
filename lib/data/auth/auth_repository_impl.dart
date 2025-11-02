import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/api_client.dart';
import '../../domain/auth/auth_repository.dart';
import 'auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;
  final SharedPreferences prefs;

  late final AuthRemoteDataSource _remote = AuthRemoteDataSource(apiClient.dio);

  AuthRepositoryImpl({required this.apiClient, required this.prefs});

  @override
  Future<String?> checkToken() async {
    final token = prefs.getString('token');
    return token;
  }

  @override
  Future<String> login({required String email, required String password}) async {
    // Gunakan loginDetailed agar bisa menyimpan customerId bila tersedia
    final result = await _remote.loginDetailed(email, password);
    apiClient.setToken(result.token);
    if (result.customerId != null && result.customerId!.isNotEmpty) {
      // Simpan customerId untuk dipakai oleh ProfileBloc
      await prefs.setString('customer_id', result.customerId!);
    }
    return result.token;
  }

  @override
  Future<String> register({required String name, required String email, required String password}) async {
    final token = await _remote.register(name, email, password);
    apiClient.setToken(token);
    return token;
  }

  @override
  Future<void> logout() async {
    await _remote.logout();
    apiClient.clearToken();
  }
}