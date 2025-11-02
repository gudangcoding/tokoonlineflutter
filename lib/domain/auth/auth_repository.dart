abstract class AuthRepository {
  Future<String?> checkToken();
  Future<String> login({required String email, required String password});
  Future<String> register({required String name, required String email, required String password});
  Future<void> logout();
}