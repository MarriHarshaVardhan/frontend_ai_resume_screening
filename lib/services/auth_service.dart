import 'api_service.dart';
import '../core/constants/app_constants.dart';
import '../core/constants/user_session.dart';

class AuthService {
  // ================= REGISTER =================

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String contact,
    required String password,
  }) async {
    final response = await ApiService.post(
      AppConstants.registrationEndpoint,
      body: {
        'data': {
          'registration': {
            'name': name,
            'email': email,
            'contact': contact,
            'password': password,
          }
        }
      },
      authorized: false,
    );

    if (response is Map<String, dynamic>) {
      final token = response['access_token'];

      if (token != null && token.toString().isNotEmpty) {
        await UserSession.login(
          email: response['email'] ?? email,
          name: response['name'] ?? name,
          token: token.toString(),
        );
      }

      return response;
    }

    throw Exception('Invalid registration response');
  }

  // ================= LOGIN =================

  static Future<Map<String, dynamic>> login({
    required String emailOrMobile,
    required String password,
  }) async {
    final response = await ApiService.post(
      AppConstants.loginEndpoint,
      body: {
        'data': {
          'login': {
            'email_or_mobile': emailOrMobile,
            'password': password,
          }
        }
      },
      authorized: false,
    );

    if (response is Map<String, dynamic>) {
      final token = response['access_token'];

      if (token != null && token.toString().isNotEmpty) {
        await UserSession.login(
          email: response['email'] ?? emailOrMobile,
          name: response['name'],
          token: token.toString(),
        );
      }

      return response;
    }

    throw Exception('Invalid login response');
  }

  // ================= GET PROFILE =================

  static Future<Map<String, dynamic>> getProfile() async {
    final response = await ApiService.get(
      AppConstants.profileEndpoint,
      authorized: true,
    );

    if (response is Map<String, dynamic>) {
      return response;
    }

    throw Exception('Invalid profile response');
  }

  // ================= LOGOUT =================

  static Future<void> logout() async {
    await UserSession.logout();
  }
}