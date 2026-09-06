import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import 'api_service.dart';
import '../core/constants/app_constants.dart';
import '../core/constants/user_session.dart';

class ResumeService {
  // ==============================
  // UPLOAD RESUME
  // ==============================

  static Future<Map<String, int>> uploadResume(
    PlatformFile file,
    String jobTitle,
    List<String> requiredSkills,
  ) async {
    final token = await UserSession.getToken();

    final uri = Uri.parse(
      '${AppConstants.baseUrl}/resume/upload',
    );

    final request = http.MultipartRequest(
      'POST',
      uri,
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    request.fields['job_title'] = jobTitle;

    request.fields['required_skills'] = jsonEncode(
      requiredSkills,
    );

    // WEB: file.bytes
    // MOBILE/DESKTOP: file.path
    if (file.bytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          file.bytes!,
          filename: file.name,
        ),
      );
    } else if (file.path != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path!,
          filename: file.name,
        ),
      );
    } else {
      throw Exception(
        'Unable to read selected resume file',
      );
    }

    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(
      streamedResponse,
    );

    dynamic responseData;

    try {
      responseData = jsonDecode(response.body);
    } catch (_) {
      responseData = response.body;
    }

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      if (responseData is Map<String, dynamic>) {
        final resumeId = responseData['resume_id'];
        final jobId = responseData['job_id'];

        if (resumeId == null || jobId == null) {
          throw Exception(
            'Resume ID or Job ID was not returned by the server',
          );
        }

        return {
          'resume_id': resumeId as int,
          'job_id': jobId as int,
        };
      }

      throw Exception(
        'Invalid upload response received from server',
      );
    } else {
      String errorMessage = 'Resume upload failed';

      if (responseData is Map<String, dynamic>) {
        errorMessage =
            responseData['detail'] ??
            responseData['message'] ??
            errorMessage;
      }

      throw Exception(errorMessage);
    }
  }

  // ==============================
  // EXTRACT RESUME TEXT
  // ==============================

  static Future<void> extractText(
    int resumeId,
  ) async {
    await ApiService.post(
      '/resume/extract-text/$resumeId',
      authorized: true,
    );
  }

  // ==============================
  // CLEAN RESUME TEXT
  // ==============================

  static Future<void> cleanText(
    int resumeId,
  ) async {
    await ApiService.post(
      '/resume/clean-text/$resumeId',
      authorized: true,
    );
  }

  // ==============================
  // ANALYZE RESUME WITH AI
  // ==============================

  static Future<int> analyzeResume(
    int resumeId,
    int jobId,
  ) async {
    final response = await ApiService.post(
      '/resume/analyze/$resumeId/$jobId',
      authorized: true,
    );

    if (response is Map<String, dynamic>) {
      final screeningId = response['screening_id'];

      if (screeningId == null) {
        throw Exception(
          'Screening ID was not returned by the server',
        );
      }

      // Handles both int and numeric values safely
      if (screeningId is int) {
        return screeningId;
      }

      return int.parse(
        screeningId.toString(),
      );
    }

    throw Exception(
      'Invalid response received from server',
    );
  }

  // ==============================
  // COMPLETE SCREENING FLOW
  // ==============================

  static Future<int> startScreening(
    PlatformFile file,
    String jobTitle,
    List<String> requiredSkills,
  ) async {
    // STEP 1: Upload Resume
    final uploadData = await uploadResume(
      file,
      jobTitle,
      requiredSkills,
    );

    final resumeId = uploadData['resume_id']!;

    final jobId = uploadData['job_id']!;

    // STEP 2: Extract Resume Text
    await extractText(resumeId);

    // STEP 3: Clean Resume Text
    await cleanText(resumeId);

    // STEP 4: AI Resume Analysis
    final screeningId = await analyzeResume(
      resumeId,
      jobId,
    );

    return screeningId;
  }
}