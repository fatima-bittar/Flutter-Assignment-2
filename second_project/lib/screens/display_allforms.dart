import 'package:flutter/material.dart';
import '../services/form_service.dart';
import '../utils/auth_provider.dart';
import 'create_form_screen.dart';
import 'submission_list_screen.dart';
import 'package:provider/provider.dart';

class DisplayAllForms extends StatefulWidget {
  const DisplayAllForms({super.key});

  @override
  State<DisplayAllForms> createState() => _DisplayAllFormsState();
}

class _DisplayAllFormsState extends State<DisplayAllForms> {
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
          const SnackBar(content: Text('Form deleted successfully!')),
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

  void _navigateToFormSubmissionScreen(int? formId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubmissionsScreen(
          formId: formId ?? 0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final role = userProvider.role;

    return Scaffold(
      appBar: AppBar(title: const Text('Available Forms')),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchAllForms(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No forms available'));
          }

          final forms = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true, // Ensures the list takes minimal space
            physics: const NeverScrollableScrollPhysics(),
            itemCount: forms.length,
            itemBuilder: (context, index) {
              final form = forms[index];
              return ListTile(
                title: Text(form['name'] ?? 'Unnamed Form'),
                onTap: () {
                  _navigateToFormSubmissionScreen(form['id']);
                },
                trailing: role == "admin"
                    ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteForm(form['id']),
                    ),
                  ],
                )
                    : null, // Hide buttons for non-admin users
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
