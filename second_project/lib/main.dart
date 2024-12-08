import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/display_allforms.dart';
import 'screens/get_all_users.dart';
import 'screens/registration_login_screen.dart';  // Your AuthScreen (Login/Register)
import 'screens/admin_dashboard_screen.dart';  // Your Admin Dashboard screen
import 'screens/user_dashboard.dart';
import 'utils/auth_provider.dart';  // Import the provider

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Define the routes for your application
      routes: {
        '/': (context) => const AuthScreen(), // Your login/register screen
        '/admin_dashboard': (context) => const AdminDashboard(),  // Admin dashboard route
        '/user_dashboard': (context) => const UserDashboard(), // User dashboard route
        '/get_all_users' : (context) => const AllUsersScreen(),
        '/get_all_forms': (context) => const DisplayAllForms(),
      },
    );
  }
}
