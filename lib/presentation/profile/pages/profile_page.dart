import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../component/app_text_input.dart';
import '../../component/app_snackbar.dart';
import '../../component/validators.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  Uint8List? _pickedBytes;
  String? _pickedName;

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfile());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickFromGallery() async {
    final res = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
    if (res != null && res.files.isNotEmpty && res.files.first.bytes != null) {
      setState(() {
        _pickedBytes = res.files.first.bytes!;
        _pickedName = res.files.first.name;
      });
    }
  }

  Future<void> _captureFromCamera() async {
    if (kIsWeb) {
      await _pickFromGallery();
      return;
    }
    final picker = ImagePicker();
    final xfile = await picker.pickImage(source: ImageSource.camera, imageQuality: 85);
    if (xfile != null) {
      final bytes = await xfile.readAsBytes();
      setState(() {
        _pickedBytes = bytes;
        _pickedName = xfile.name;
      });
    }
  }

  void _uploadPhoto() {
    final bytes = _pickedBytes;
    final name = _pickedName;
    if (bytes == null || name == null) return;
    context.read<ProfileBloc>().add(UploadProfilePhoto(bytes: bytes, filename: name));
  }

  void _submit() {
    context.read<ProfileBloc>().add(UpdateProfile(name: _nameController.text.trim(), email: _emailController.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state.message != null && state.message!.isNotEmpty) {
              AppSnackbar.show(context, state.message!, type: SnackbarType.info);
            }
          },
          builder: (context, state) {
            _nameController.text = state.name ?? '';
            _emailController.text = state.email ?? '';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
                const SizedBox(height: 12),
                Form(
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
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                if (_pickedBytes != null) ...[
                  Text('Preview Foto', style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(_pickedBytes!, width: 120, height: 120, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: state.loading ? null : _captureFromCamera,
                      icon: const Icon(Icons.photo_camera),
                      label: const Text('Ambil dari Kamera'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: state.loading ? null : _pickFromGallery,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Pilih dari Galeri'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      onPressed: state.loading || _pickedBytes == null ? null : _uploadPhoto,
                      icon: const Icon(Icons.cloud_upload),
                      label: const Text('Upload Foto'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const SizedBox(height: 24),
                ElevatedButton(onPressed: state.loading ? null : _submit, child: state.loading ? const CircularProgressIndicator() : const Text('Perbarui Profil')),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => context.read<AuthBloc>().add(AuthLogoutRequested()),
                  child: const Text('Keluar'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}