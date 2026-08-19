class Validators {
  Validators._();

  static String? required(String? value, {String fieldName = 'Ce champ'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName est requis';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) return null;
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value)) {
      return 'Email invalide';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) return null;
    final regex = RegExp(r'^[0-9]{10}$');
    if (!regex.hasMatch(value.replaceAll(' ', ''))) {
      return 'Telephone invalide (10 chiffres)';
    }
    return null;
  }

  static String? minLength(String? value, int min, {String fieldName = 'Ce champ'}) {
    if (value == null || value.length < min) {
      return '$fieldName doit contenir au moins $min caracteres';
    }
    return null;
  }
}
