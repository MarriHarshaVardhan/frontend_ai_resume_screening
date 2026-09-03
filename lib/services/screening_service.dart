import 'api_service.dart';

class ScreeningService {
  static Future<Map<String, dynamic>> getScreeningResult(
    int screeningId,
  ) async {
    final response = await ApiService.get(
      '/screening/$screeningId',
      authorized: true,
    );

    if (response is Map<String, dynamic>) {
      return response;
    }

    if (response is Map) {
      return Map<String, dynamic>.from(response);
    }

    throw Exception(
      'Invalid screening result received from server',
    );
  }
}