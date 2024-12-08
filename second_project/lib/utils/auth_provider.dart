import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? _role;
  int? _userId;
  String? _token;

  String? get role => _role;
  int? get userId => _userId;
  String? get token => _token;

  // Method to set the token
  void setToken(String token) {
    _token = token;
    notifyListeners(); // Notify listeners when the token changes
  }
  // Method to set the role and userId
  void setUser(String role, int userId) {
    _role = role;
    _userId = userId;
    notifyListeners(); // Notify listeners about the changes
  }

  // Method to clear user data (e.g., for logout)
  void clearUserData() {
    _role = null;
    _userId = null;
    _token = null;
    notifyListeners();
  }
}
