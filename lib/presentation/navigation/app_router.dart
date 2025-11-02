import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_state.dart';
import '../auth/pages/login_page.dart';
import '../auth/pages/register_page.dart';
import '../splash/splash_page.dart';
import '../dashboard/dashboard_page.dart';
import '../products/pages/product_detail_page.dart';
import '../products/pages/search_page.dart';
import '../cart/pages/checkout_page.dart';
import '../profile/pages/profile_page.dart';

class AppRouter {
  static GoRouter create() {
    return GoRouter(
      initialLocation: '/splash',
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: '/',
          name: 'dashboard',
          builder: (context, state) => const DashboardPage(),
        ),
        GoRoute(
          path: '/product/:id',
          builder: (context, state) => ProductDetailPage(id: state.pathParameters['id']!),
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => const SearchPage(),
        ),
        GoRoute(
          path: '/checkout',
          builder: (context, state) => const CheckoutPage(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfilePage(),
        ),
      ],
      redirect: (context, state) {
        final authState = context.read<AuthBloc>().state;
        final loggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';
        final atSplash = state.matchedLocation == '/splash';

        // Tahan di splash saat status belum diketahui, hindari redirect loop
        if (authState.status == AuthStatus.unknown) {
          return atSplash ? null : '/splash';
        }
        // Jika belum login dan bukan di halaman login/register, arahkan ke login
        if (authState.status == AuthStatus.unauthenticated && !loggingIn) {
          return atSplash ? null : '/login';
        }
        // Jika sudah login dan mencoba akses login/register, arahkan ke beranda
        if (authState.status == AuthStatus.authenticated && loggingIn) {
          return '/';
        }
        return null; // tidak ada redirect
      },
    );
  }
}