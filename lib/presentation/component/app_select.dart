import 'package:flutter/material.dart';

class AppSelect<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String label;
  final String Function(T) itemLabel;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;

  const AppSelect({
    super.key,
    required this.value,
    required this.items,
    required this.label,
    required this.itemLabel,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items
          .map((e) => DropdownMenuItem<T>(value: e, child: Text(itemLabel(e))))
          .toList(),
      decoration: InputDecoration(labelText: label),
      onChanged: onChanged,
      validator: validator ?? (v) => v == null ? 'Pilih salah satu' : null,
    );
  }
}