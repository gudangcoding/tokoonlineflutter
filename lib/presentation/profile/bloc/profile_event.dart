abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final String name;
  final String email;
  UpdateProfile({required this.name, required this.email});
}

class UploadProfilePhoto extends ProfileEvent {
  final List<int> bytes;
  final String filename;
  UploadProfilePhoto({required this.bytes, required this.filename});
}