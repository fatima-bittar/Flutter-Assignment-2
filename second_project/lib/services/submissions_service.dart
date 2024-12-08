import 'dart:convert';
import 'package:http/http.dart' as http;

class SubmissionService {
  static const String baseUrl = 'http://192.168.99.36:3000/api';

  // Submit form data
  static Future<void> submitFormData({
    required int formId,
    required Map<String, dynamic> formData,
    required String token, // Token for authentication
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/forms/$formId/submit'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Include token
        },
        body: jsonEncode({'data': formData}),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to submit form. Status Code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (error) {
      print('Error in SubmissionService.submitFormData: $error');
      rethrow;
    }
  }

  // Fetch all submissions for a specific form
  static Future<List<dynamic>> fetchSubmissionsByFormId({
    required int formId,
    required String token, // Token for authentication
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/forms/$formId/submissions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Include token
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Failed to fetch submissions. Status Code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (error) {
      print('Error in SubmissionService.fetchSubmissionsByFormId: $error');
      rethrow;
    }
  }

  // Delete a submission by ID
  static Future<void> deleteSubmission({
    required int submissionId,
    required String token, // Token for authentication
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/forms/submissions/$submissionId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Include token
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to delete submission. Status Code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (error) {
      print('Error in SubmissionService.deleteSubmission: $error');
      rethrow;
    }
  }
}
