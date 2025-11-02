import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../component/app_text_input.dart';
import '../../component/app_snackbar.dart';
import '../../component/validators.dart';
import '../../component/app_wave_header.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthRegisterRequested(
          _nameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Daftar')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            context.go('/');
          }
          if (state.status == AuthStatus.error) {
            AppSnackbar.show(
              context,
              state.message ?? 'Terjadi kesalahan',
              type: SnackbarType.error,
            );
          }
        },
        builder: (context, state) {
          final loading = state.status == AuthStatus.loading;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AppWaveHeader(height: 180),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppTextInput(
                          controller: _nameController,
                          label: 'Nama',
                          validator: Validators.required('Nama wajib diisi'),
                        ),
                        const SizedBox(height: 12),
                        AppEmailInput(
                          controller: _emailController,
                          validator: Validators.required('Email wajib diisi'),
                        ),
                        const SizedBox(height: 12),
                        AppPasswordInput(
                          controller: _passwordController,
                          validator: Validators.combine([
                            Validators.required('Password wajib diisi'),
                            Validators.minLength(6, 'Minimal 6 karakter'),
                          ]),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: loading ? null : _submit,
                          child: loading
                              ? const CircularProgressIndicator()
                              : const Text('Daftar'),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () => context.go('/login'),
                          child: const Text('Sudah punya akun? Masuk'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
