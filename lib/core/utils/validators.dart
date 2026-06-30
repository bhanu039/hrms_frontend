class Validators {
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return "Password required";
    }
    if (value.length < 6) {
      return "Minimum 6 characters";
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "Must contain uppercase letter";
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Must contain a number";
    }
    return null;
  }
}