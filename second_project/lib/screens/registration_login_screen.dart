import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_service.dart';
import '../utils/auth_provider.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController(); // Added username controller
  bool _isRegistering = false;

  // Authenticate method to handle both login and registration
  Future<void> _authenticate() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final username = _usernameController.text.trim(); // Get username input

    if (email.isEmpty || password.isEmpty || (_isRegistering && username.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    try {
      if (_isRegistering) {
        // Registration logic
        print('Attempting to register user...');
        final response = await UserService.register({
          'email': email,
          'password': password,
          'username': username, // Include username in the request
        });
        print('Registration Response: $response');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful. Please log in.')),
        );
        setState(() {
          _isRegistering = false;
        });
      } else {
        // Login logic
        print('Attempting to log in user...');
        final response = await UserService.login(email, password);
        print('Login Response: $response');

        final token = response['token']; // Extract token from the response
        final role = response['role']; // Extract role from the response
        final userId = response['userId']; // Extract userId from the response

        // Save the user data in the UserProvider
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setToken(token);
        userProvider.setUser(role, userId);

        print('Token: $token, Role: $role, User ID: $userId');

        // Navigate based on role
        if (role == 'admin') {
          Navigator.pushReplacementNamed(context, '/admin_dashboard');
        } else {
          Navigator.pushReplacementNamed(context, '/user_dashboard');
        }
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isRegistering ? 'Register' : 'Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_isRegistering) // Only show username field during registration
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _authenticate,
              child: Text(_isRegistering ? 'Register' : 'Login'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isRegistering = !_isRegistering;
                });
              },
              child: Text(_isRegistering
                  ? 'Already have an account? Login'
                  : 'Don\'t have an account? Register'),
            ),
          ],
        ),
      ),
    );
  }
}
