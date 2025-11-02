import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ApiClient apiClient;
  ProfileBloc(this.apiClient) : super(const ProfileState()) {
    on<LoadProfile>(_onLoad);
    on<UpdateProfile>(_onUpdate);
    on<UploadProfilePhoto>(_onUploadPhoto);
  }

  Future<void> _onLoad(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(loading: true));
    try {
      // Upayakan menggunakan endpoint customers/{customer} sesuai arahan
      final customerId = apiClient.prefs.getString('customer_id');
      final res = (customerId != null && customerId.isNotEmpty)
          ? await apiClient.get('/customers/$customerId')
          : await apiClient.get('/profile');
      final data = res.data as Map<String, dynamic>;
      // Respons bisa berupa object langsung, atau dibungkus dalam 'data'
      final source = (data['data'] is Map<String, dynamic>) ? (data['data'] as Map<String, dynamic>) : data;
      emit(state.copyWith(name: source['name'] as String?, email: source['email'] as String?, loading: false));
    } catch (e) {
      emit(state.copyWith(message: 'Gagal memuat profil: $e', loading: false));
    }
  }

  Future<void> _onUpdate(UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(loading: true));
    try {
      final customerId = apiClient.prefs.getString('customer_id');
      if (customerId != null && customerId.isNotEmpty) {
        await apiClient.put('/customers/$customerId', data: {'name': event.name, 'email': event.email});
      } else {
        await apiClient.put('/profile', data: {'name': event.name, 'email': event.email});
      }
      emit(state.copyWith(name: event.name, email: event.email, loading: false));
    } catch (e) {
      emit(state.copyWith(message: 'Gagal memperbarui profil: $e', loading: false));
    }
  }

  Future<void> _onUploadPhoto(UploadProfilePhoto event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(loading: true));
    try {
      final customerId = apiClient.prefs.getString('customer_id');
      final form = FormData.fromMap({
        // Sesuaikan key jika backend menggunakan 'avatar' atau 'image'
        'photo': MultipartFile.fromBytes(event.bytes, filename: event.filename),
      });
      if (customerId != null && customerId.isNotEmpty) {
        await apiClient.put('/customers/$customerId', data: form);
      } else {
        await apiClient.put('/profile', data: form);
      }
      // Setelah upload, muat ulang profil untuk menyegarkan UI
      add(LoadProfile());
      emit(state.copyWith(loading: false));
    } catch (e) {
      emit(state.copyWith(message: 'Gagal mengunggah foto: $e', loading: false));
    }
  }
}