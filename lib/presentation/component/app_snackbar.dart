import 'package:flutter/material.dart';

enum SnackbarType { success, error, info }

class AppSnackbar {
  static void show(BuildContext context, String message, {SnackbarType type = SnackbarType.info}) {
    final scheme = Theme.of(context).colorScheme;
    Color bg;
    switch (type) {
      case SnackbarType.success:
        bg = scheme.primaryContainer;
        break;
      case SnackbarType.error:
        bg = scheme.errorContainer;
        break;
      case SnackbarType.info:
        bg = scheme.secondaryContainer;
        break;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: bg,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}