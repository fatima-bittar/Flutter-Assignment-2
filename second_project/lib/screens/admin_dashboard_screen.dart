import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'modules_screen.dart';
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
      // appBar: AppBar(title: const Text("Admin Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome, Admin!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.visibility, color: Colors.blue),
                title: const Text("View Modules"),
                onTap: () {
                  // Navigate to DisplayAllForms screen
                  Navigator.pushNamed(context, '/get_all_forms');
                },
              ),
            ),
            const SizedBox(height: 16),
            if (role == 'admin') // Show this button only for admins
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(Icons.group, color: Colors.green),
                  title: const Text("View All Users"),
                  onTap: () {
                    // Navigate to get all users screen (only for admin)
                    Navigator.pushNamed(context, '/get_all_users');
                  },
                ),
              ),
           ]
        ),
      ),
    );
  }
}
