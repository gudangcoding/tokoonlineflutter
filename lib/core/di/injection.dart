import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_client.dart';
import '../config/app_config.dart';
import '../../data/auth/auth_repository_impl.dart';
import '../../domain/auth/auth_repository.dart';
import '../../presentation/auth/bloc/auth_bloc.dart';
import '../../data/products/product_repository_impl.dart';
import '../../domain/products/product_repository.dart';
import '../../presentation/products/bloc/product_bloc.dart';
import '../../presentation/products/bloc/product_event.dart';
import '../../presentation/cart/bloc/cart_bloc.dart';
import '../../presentation/profile/bloc/profile_bloc.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Shared Preferences
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  // Dio client
  final dio = Dio(BaseOptions(
    baseUrl: AppConfig.baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 20),
    headers: {
      'Accept': 'application/json',
    },
  ));

  final apiClient = ApiClient(dio, prefs);
  getIt.registerSingleton<ApiClient>(apiClient);

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(() =>
      AuthRepositoryImpl(apiClient: apiClient, prefs: prefs));
  getIt.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(apiClient));

  // BLoCs
  getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt<AuthRepository>()));
  getIt.registerFactory<ProductBloc>(() => ProductBloc(getIt<ProductRepository>()));
  getIt.registerLazySingleton<CartBloc>(() => CartBloc(apiClient: apiClient));
  getIt.registerLazySingleton<ProfileBloc>(() => ProfileBloc(apiClient));
}