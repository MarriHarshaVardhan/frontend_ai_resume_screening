import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static String userName = 'User';
  static String userEmail = '';
  static String accessToken = '';

  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _accessTokenKey = 'access_token';

  static String get initials {
    final cleanName = userName.trim();

    if (cleanName.isEmpty) return 'U';

    final parts = cleanName.split(RegExp(r'\s+'));

    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    } else if (parts[0].isNotEmpty) {
      return parts[0]
          .substring(0, parts[0].length >= 2 ? 2 : 1)
          .toUpperCase();
    }

    return 'U';
  }

  // Save user session after Login or Registration
  static Future<void> login({
    required String email,
    required String token,
    String? name,
  }) async {
    userEmail = email.trim();
    accessToken = token;

    if (name != null && name.trim().isNotEmpty) {
      userName = name.trim();
    } else {
      final prefix = email.split('@').first;

      final formatted = prefix
          .replaceAll(RegExp(r'[._-]'), ' ')
          .split(' ')
          .where((word) => word.isNotEmpty)
          .map(
            (word) =>
                word[0].toUpperCase() +
                (word.length > 1 ? word.substring(1) : ''),
          )
          .join(' ')
          .trim();

      userName = formatted.isNotEmpty ? formatted : 'User';
    }

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_userNameKey, userName);
    await prefs.setString(_userEmailKey, userEmail);
    await prefs.setString(_accessTokenKey, accessToken);
  }

  // Load saved session when app starts
  static Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();

    userName = prefs.getString(_userNameKey) ?? 'User';
    userEmail = prefs.getString(_userEmailKey) ?? '';
    accessToken = prefs.getString(_accessTokenKey) ?? '';
  }

  // Check whether user is logged in
  static bool get isLoggedIn {
    return accessToken.isNotEmpty;
  }

  // Logout and clear saved session
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_userNameKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_accessTokenKey);

    userName = 'User';
    userEmail = '';
    accessToken = '';
  }

  // Get the current access token
  static Future<String> getToken() async {
    return accessToken;
  }
}