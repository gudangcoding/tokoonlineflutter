enum AuthStatus { unknown, authenticated, unauthenticated, loading, error }

class AuthState {
  final AuthStatus status;
  final String? message;

  const AuthState({required this.status, this.message});

  factory AuthState.unknown() => const AuthState(status: AuthStatus.unknown);
  factory AuthState.loading() => const AuthState(status: AuthStatus.loading);
  factory AuthState.authenticated() => const AuthState(status: AuthStatus.authenticated);
  factory AuthState.unauthenticated([String? message]) => AuthState(status: AuthStatus.unauthenticated, message: message);
  factory AuthState.error(String message) => AuthState(status: AuthStatus.error, message: message);
}