import 'api_service.dart';

class ScreeningService {

  static Future<List<Map<String, dynamic>>> getScreenings() async {
    final response = await ApiService.get(
      '/api/screenings',
      authorized: true,
    );

    if (response is Map<String, dynamic>) {
      final data = response['data'];

      if (data is Map<String, dynamic>) {
        final screenings = data['recent_screenings'];

        if (screenings is List) {
          return screenings
              .map(
                (item) => Map<String, dynamic>.from(item),
              )
              .toList();
        }
      }
    }

    throw Exception(
      'Invalid screenings response received from server',
    );
  }

  static Future<List<Map<String, dynamic>>>
      getRecentScreenings() async {

    final response = await ApiService.get(
      '/api/screenings/recent',
      authorized: true,
    );

    if (response is Map<String, dynamic>) {
      final data = response['data'];

      if (data is Map<String, dynamic>) {
        final screenings = data['recent_screenings'];

        if (screenings is List) {
          return screenings
              .map(
                (item) => Map<String, dynamic>.from(item),
              )
              .toList();
        }
      }
    }

    throw Exception(
      'Invalid recent screenings response received from server',
    );
  }

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