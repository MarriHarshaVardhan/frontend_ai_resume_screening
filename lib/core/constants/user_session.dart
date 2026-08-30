class UserSession {
  static String userName = 'User';
  static String userEmail = '';

  static String get initials {
    final cleanName = userName.trim();
    if (cleanName.isEmpty) return 'U';
    final parts = cleanName.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    } else if (parts[0].isNotEmpty) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return 'U';
  }

  static void login({required String email, String? name}) {
    userEmail = email.trim();
    if (name != null && name.trim().isNotEmpty) {
      userName = name.trim();
    } else {
      // Derive name from email prefix (e.g. "firoz.syed@..." -> "Firoz Syed")
      final prefix = email.split('@').first;
      final formatted = prefix
          .replaceAll(RegExp(r'[._-]'), ' ')
          .split(' ')
          .where((w) => w.isNotEmpty)
          .map((word) => word[0].toUpperCase() + (word.length > 1 ? word.substring(1) : ''))
          .join(' ')
          .trim();
      userName = formatted.isNotEmpty ? formatted : 'User';
    }
  }

  static void logout() {
    userName = 'User';
    userEmail = '';
  }
}
