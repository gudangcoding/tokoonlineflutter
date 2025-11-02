import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/auth/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthState.unknown()) {
    on<AuthCheckRequested>(_onCheck);
    on<AuthLoginRequested>(_onLogin);
    on<AuthRegisterRequested>(_onRegister);
    on<AuthLogoutRequested>(_onLogout);
  }

  Future<void> _onCheck(AuthCheckRequested event, Emitter<AuthState> emit) async {
    emit(AuthState.loading());
    final token = await repository.checkToken();
    if (token != null && token.isNotEmpty) {
      emit(AuthState.authenticated());
    } else {
      emit(AuthState.unauthenticated());
    }
  }

  Future<void> _onLogin(AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthState.loading());
    try {
      await repository.login(email: event.email, password: event.password);
      emit(AuthState.authenticated());
    } catch (e) {
      emit(AuthState.error('Login gagal: $e'));
      emit(AuthState.unauthenticated('Login gagal'));
    }
  }

  Future<void> _onRegister(AuthRegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthState.loading());
    try {
      await repository.register(name: event.name, email: event.email, password: event.password);
      emit(AuthState.authenticated());
    } catch (e) {
      emit(AuthState.error('Register gagal: $e'));
      emit(AuthState.unauthenticated('Register gagal'));
    }
  }

  Future<void> _onLogout(AuthLogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthState.loading());
    await repository.logout();
    emit(AuthState.unauthenticated());
  }
}