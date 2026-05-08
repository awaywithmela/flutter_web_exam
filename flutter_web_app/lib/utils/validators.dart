class Validators {
  static String? required(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required';
    }
    return null;
  }

  static String? email(String? value) {
    final requiredMessage = required(value, 'Email');
    if (requiredMessage != null) {
      return requiredMessage;
    }

    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailPattern.hasMatch(value!.trim())) {
      return 'Enter a valid email';
    }

    return null;
  }

  static String? password(String? value) {
    final requiredMessage = required(value, 'Password');
    if (requiredMessage != null) {
      return requiredMessage;
    }

    if (value!.length < 8) {
      return 'Use at least 8 characters';
    }

    return null;
  }
}
