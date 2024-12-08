import 'dart:convert';
import 'package:http/http.dart' as http;

class FormService {
  static const String baseUrl = 'http://192.168.99.36:3000/api';

  // Fetch form structure
  static Future<Map<String, dynamic>?> fetchFormStructure({
    required int formId,
    required String token,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/forms/form_structure/$formId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print("API Response for form structure: ${response.body}");
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch form structure');
    }
  }

  // Fetch all forms
  static Future<List<dynamic>> fetchAllForms({required String token}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/forms/form_structures'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);

    } else {
      throw Exception(
          'Failed to fetch all forms. Status Code: ${response.statusCode}');
    }
  }

  // Add a new form
  static Future<Map<String, dynamic>> addForm({
    required Map<String, dynamic> formData,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/forms/create_form'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(formData),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Failed to add form. Status Code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (error) {
      print('Error in FormService.addForm: $error');
      rethrow;
    }
  }

  // Edit an existing form
  static Future<Map<String, dynamic>> editForm({
    required int formId,
    required Map<String, dynamic> formData,
    required String token,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/forms/$formId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(formData),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Failed to edit form. Status Code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (error) {
      print('Error in FormService.editForm: $error');
      rethrow;
    }
  }

  // Delete a form
  static Future<void> deleteForm({
    required int formId,
    required String token,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/forms/$formId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to delete form. Status Code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (error) {
      print('Error in FormService.deleteForm: $error');
      rethrow;
    }
  }
}
