import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constants/app_constants.dart';
import '../core/constants/user_session.dart';

class ApiService {
  // Build complete API URL
  static Uri buildUrl(String endpoint) {
    return Uri.parse(
      '${AppConstants.baseUrl}$endpoint',
    );
  }

  // Common headers
  static Map<String, String> get headers {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  // Headers with JWT Authorization Token
  static Map<String, String> get authorizedHeaders {
    final headersWithToken = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (UserSession.accessToken.isNotEmpty) {
      headersWithToken['Authorization'] =
          'Bearer ${UserSession.accessToken}';
    }

    return headersWithToken;
  }

  // Common GET request
  static Future<dynamic> get(
    String endpoint, {
    bool authorized = true,
  }) async {
    try {
      final response = await http
          .get(
            buildUrl(endpoint),
            headers: authorized
                ? authorizedHeaders
                : headers,
          )
          .timeout(
            const Duration(seconds: 30),
          );

      return _handleResponse(response);
    } catch (error) {
      throw Exception(
        'Failed to connect to server: $error',
      );
    }
  }

  // Common POST request
  static Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool authorized = false,
  }) async {
    try {
      final response = await http
          .post(
            buildUrl(endpoint),
            headers: authorized
                ? authorizedHeaders
                : headers,
            body: body != null
                ? jsonEncode(body)
                : null,
          )
          .timeout(
            const Duration(seconds: 60),
          );

      return _handleResponse(response);
    } catch (error) {
      throw Exception(
        'Failed to connect to server: $error',
      );
    }
  }

  // Handle Backend Response
  static dynamic _handleResponse(
    http.Response response,
  ) {
    dynamic responseData;

    try {
      responseData = jsonDecode(response.body);
    } catch (_) {
      responseData = response.body;
    }

    // Success response
    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return responseData;
    }

    String errorMessage =
        'Something went wrong. Please try again.';

    if (responseData is Map<String, dynamic>) {
      final detail = responseData['detail'];
      final message = responseData['message'];

      if (detail != null) {
        errorMessage = detail.toString();
      } else if (message != null) {
        errorMessage = message.toString();
      }
    }

    throw Exception(
      'Error ${response.statusCode}: $errorMessage',
    );
  }
}