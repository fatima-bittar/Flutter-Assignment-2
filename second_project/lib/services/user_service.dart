import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static const String baseUrl = 'http://192.168.99.36:3000/api/users';

  // Register a new user
  static Future<Map<String, dynamic>> register(Map<String, String> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );
    if (response.statusCode == 201) {
      print(response.body);
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register user');
    }
  }

  // Login user
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }

  // Get all users
  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print (response.body);
      final List<dynamic> data = jsonDecode(response.body);
      print(data);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  // Get user by ID
  static Future<Map<String, dynamic>> getUserById(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$userId'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch user');
    }
  }

  // Delete user by ID
  static Future<void> deleteUserById(int userId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$userId'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }
}
