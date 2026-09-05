import 'api_service.dart';

class DashboardService {
  static Future<Map<String, dynamic>> getStats() async {
    final response = await ApiService.get(
      '/api/dashboard/stats',
      authorized: true,
    );

    if (response is Map<String, dynamic>) {
      return response;
    }

    if (response is Map) {
      return Map<String, dynamic>.from(response);
    }

    throw Exception(
      'Invalid dashboard stats response',
    );
  }
}