import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'display_allforms.dart';
import '../utils/auth_provider.dart'; // Import the UserProvider

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // Access role and userId from UserProvider
    final userProvider = Provider.of<UserProvider>(context);
    final role = userProvider.role;
    final userId = userProvider.userId;


    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to DisplayAllForms screen, passing role and userId
                Navigator.pushNamed(context, '/get_all_forms');
              },
              child: const Text("View All Forms"),
            ),
            if (role == 'admin') // Show this button only for admins
              ElevatedButton(
                onPressed: () {
                  // Navigate to get all users screen (only for admin)
                  Navigator.pushNamed(context, '/get_all_users');
                },
                child: const Text("View All Users"),
              ),
          ],
        ),
      ),
    );
  }
}
