import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class AppUploadFile extends StatefulWidget {
  final String label;
  final List<String>? allowedExtensions;
  final void Function(PlatformFile file)? onFilePicked;

  const AppUploadFile({
    super.key,
    required this.label,
    this.allowedExtensions,
    this.onFilePicked,
  });

  @override
  State<AppUploadFile> createState() => _AppUploadFileState();
}

class _AppUploadFileState extends State<AppUploadFile> {
  PlatformFile? _file;

  Future<void> _pick() async {
    final res = await FilePicker.platform.pickFiles(
      type: widget.allowedExtensions == null ? FileType.any : FileType.custom,
      allowedExtensions: widget.allowedExtensions,
      withData: true,
    );
    if (res != null && res.files.isNotEmpty) {
      setState(() => _file = res.files.first);
      widget.onFilePicked?.call(_file!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: InputDecorator(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                child: Text(_file?.name ?? 'Tidak ada file dipilih'),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(onPressed: _pick, child: const Text('Pilih File')),
          ],
        ),
      ],
    );
  }
}