import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/auth_provider.dart'; // Import the UserProvider
import 'display_allforms.dart'; // Import the DisplayAllForms screen

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // Access role and userId from UserProvider
    final userProvider = Provider.of<UserProvider>(context);
    final role = userProvider.role;
    final userId = userProvider.userId;

    return Scaffold(
      appBar: AppBar(title: const Text("User Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to DisplayAllForms screen, passing role and userId
                Navigator.pushNamed(
                  context,'/get_all_forms'
                );
              },
              child: const Text("View All Forms"),
            ),
          ],
        ),
      ),
    );
  }
}
