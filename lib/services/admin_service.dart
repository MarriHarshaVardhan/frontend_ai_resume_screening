import 'dart:convert';

import 'package:http/http.dart' as http;

class AdminService {
  static const String baseUrl = 'http://127.0.0.1:8000';

  Future<Map<String, dynamic>> registerAdmin({
    required String name,
    required String email,
    required String contact,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/registration'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'contact': contact,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return data;
    }

    throw Exception(
      data['detail'] ?? 'Admin registration failed',
    );
  }

  Future<Map<String, dynamic>> loginAdmin({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(
      data['detail'] ?? 'Admin login failed',
    );
  }

  Future<Map<String, dynamic>> getDashboard(
    String token,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/dashboard'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(
      data['detail'] ?? 'Failed to load dashboard',
    );
  }

  Future<List<dynamic>> getUsers(
    String token,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/users'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(
      data['detail'] ?? 'Failed to load users',
    );
  }

  Future<List<dynamic>> getResumes(
    String token,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/resumes'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(
      data['detail'] ?? 'Failed to load resumes',
    );
  }

  Future<List<dynamic>> getScreenings(
    String token,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/screenings'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(
      data['detail'] ?? 'Failed to load screenings',
    );
  }

  Future<Map<String, dynamic>> getScreeningDetail({
    required String token,
    required int screeningId,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/screenings/$screeningId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(
      data['detail'] ?? 'Screening not found',
    );
  }
}