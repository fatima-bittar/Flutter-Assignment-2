import 'package:flutter/material.dart';
import '../services/module_service.dart';
import '../utils/auth_provider.dart';
import 'create_module_screen.dart';
import 'registration_login_screen.dart';
import 'items_screen.dart';
import 'package:provider/provider.dart';

class ModulesScreen extends StatefulWidget {
  const ModulesScreen({super.key});

  @override
  State<ModulesScreen> createState() => _ModulesScreenState();
}

class _ModulesScreenState extends State<ModulesScreen> {
  Future<List<dynamic>> _fetchAllForms() async {
    final token = Provider.of<UserProvider>(context, listen: false).token;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User is not authenticated.')),
      );
      return [];
    }
    try {
      final forms = await FormService.fetchAllForms(token: token);
      return forms;
    } catch (error) {
      print('Error fetching forms: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch forms.')),
      );
      return [];
    }
  }

  Future<void> _deleteForm(int? formId) async {
    final token = Provider.of<UserProvider>(context, listen: false).token;
    if (formId != null && token != null) {
      try {
        await FormService.deleteForm(formId: formId, token: token);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Module deleted successfully!')),
        );
        setState(() {}); // Refresh the form list
      } catch (error) {
        print('Error deleting form: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete form.')),
        );
      }
    }
  }

  void _navigateToCreateScreen(int? formId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateFormScreen(),
      ),
    ).then((_) => setState(() {})); // Refresh the form list after navigating back
  }

  void _navigateToFormSubmissionScreen(Map<String, dynamic> form) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemsScreen(
          form: form, // Pass the entire form object
        ),
      ),
    );
  }

  // Method to handle logout
  void _logout() {
    // Clear user data (e.g., token, role, etc.) in UserProvider
    Provider.of<UserProvider>(context, listen: false).logout();
    // Navigate to the AuthScreen (login/register screen)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthScreen()), // Replace with your AuthScreen
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final role = userProvider.role;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Modules'),
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout))
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchAllForms(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No modules available'));
          }

          final forms = snapshot.data!;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Two columns in the grid
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            itemCount: forms.length,
            itemBuilder: (context, index) {
              final form = forms[index];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  onTap: () {
                    _navigateToFormSubmissionScreen(form); // Pass the entire form
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Use Flexible or Expanded for dynamic sizing
                        Flexible(
                          child: Text(
                            form['name'] ?? 'Unnamed Form',
                            style: const TextStyle(
                              fontSize: 14, // Decreased font size
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis, // Truncate long text
                            maxLines: 1, // Ensure single line text
                          ),
                        ),
                        // const SizedBox(height: 5),
                        const Spacer(),
                        if (role == 'admin')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteForm(form['id']),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: role == "admin"
          ? FloatingActionButton(
        onPressed: () {
          _navigateToCreateScreen(null);
        },
        child: const Icon(Icons.add),
      )
          : null, // Hide the floating action button for non-admin users
    );
  }
}
