import 'dart:convert';
import 'package:http/http.dart' as http;

class FormService {
  static const String baseUrl = 'http://192.168.99.104:3000/api';

  static Future<Map<String, dynamic>?> fetchFormStructure(int formId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/forms/form_structure/$formId'), // Adjust URL
    );
    print("API Response for form structure: ${response.body}"); // Log the response body
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch form structure');
    }
  }

  static Future<List<dynamic>> fetchAllForms() async {
    final response = await http.get(Uri.parse('$baseUrl/forms/form_structures'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch all forms. Status Code: ${response.statusCode}');
    }
  }
  static Future<void> submitFormData( formId, Map<String, dynamic> formData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/forms/$formId/submit'), // Form ID in the URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'data': formData}), // Send only form data in the body
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to submit form. Status Code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (error) {
      print('Error in FormService.submitFormData: $error');
      rethrow;
    }
  }

}


