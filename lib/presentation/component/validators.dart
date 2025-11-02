typedef Validator = String? Function(String? value);

class Validators {
  static Validator required([String message = 'Field wajib diisi']) => (v) {
    if (v == null || v.trim().isEmpty) return message;
    return null;
  };

  static Validator email([String message = 'Format email tidak valid']) => (v) {
    if (v == null || v.trim().isEmpty) return null; // allow empty; use required separately
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!regex.hasMatch(v.trim())) return message;
    return null;
  };

  static Validator minLength(int min, [String? message]) => (v) {
    if (v == null) return null;
    if (v.length < min) return message ?? 'Minimal $min karakter';
    return null;
  };

  static Validator combine(List<Validator> validators) => (v) {
    for (final val in validators) {
      final res = val(v);
      if (res != null) return res;
    }
    return null;
  };
}