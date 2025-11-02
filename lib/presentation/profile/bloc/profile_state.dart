class ProfileState {
  final String? name;
  final String? email;
  final bool loading;
  final String? message;

  const ProfileState({this.name, this.email, this.loading = false, this.message});

  ProfileState copyWith({String? name, String? email, bool? loading, String? message}) {
    return ProfileState(
      name: name ?? this.name,
      email: email ?? this.email,
      loading: loading ?? this.loading,
      message: message ?? this.message,
    );
  }
}