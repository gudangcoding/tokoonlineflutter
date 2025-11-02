import 'package:flutter/material.dart';
import 'validators.dart';

class AppTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType keyboardType;
  final Validator? validator;
  final bool enabled;
  final int maxLines;
  final void Function(String)? onChanged;
  final Widget? prefixIcon;

  const AppTextInput({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.enabled = true,
    this.maxLines = 1,
    this.onChanged,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, hintText: hint, prefixIcon: prefixIcon),
      keyboardType: keyboardType,
      validator: validator,
      enabled: enabled,
      maxLines: maxLines,
      onChanged: onChanged,
    );
  }
}

class AppEmailInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final Validator? validator;

  const AppEmailInput({
    super.key,
    required this.controller,
    this.label = 'Email',
    this.hint,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextInput(
      controller: controller,
      label: label,
      hint: hint,
      prefixIcon: const Icon(Icons.email),
      keyboardType: TextInputType.emailAddress,
      validator: Validators.combine([
        if (validator != null) validator!,
        Validators.email(),
      ]),
    );
  }
}

class AppPasswordInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final Validator? validator;

  const AppPasswordInput({
    super.key,
    required this.controller,
    this.label = 'Password',
    this.validator,
  });

  @override
  State<AppPasswordInput> createState() => _AppPasswordInputState();
}

class _AppPasswordInputState extends State<AppPasswordInput> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
      obscureText: _obscure,
      validator: widget.validator,
    );
  }
}

class AppTextarea extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final Validator? validator;
  final int minLines;
  final int maxLines;

  const AppTextarea({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.validator,
    this.minLines = 3,
    this.maxLines = 5,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextInput(
      controller: controller,
      label: label,
      hint: hint,
      validator: validator,
      maxLines: maxLines,
    );
  }
}