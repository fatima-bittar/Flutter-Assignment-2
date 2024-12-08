import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // To access UserProvider
import '../services/submissions_service.dart';
import '../utils/auth_provider.dart';
import 'form_submission_screen.dart'; // Import FormScreen

class SubmissionsScreen extends StatefulWidget {
  final int formId; // Form ID to fetch submissions for

  // Constructor to accept role and userId
  const SubmissionsScreen({
    super.key,
    required this.formId,
  });

  @override
  State<SubmissionsScreen> createState() => _SubmissionsScreenState();
}

class _SubmissionsScreenState extends State<SubmissionsScreen> {
  late Future<List<dynamic>> _submissionsFuture;

  @override
  void initState() {
    super.initState();
    _fetchSubmissions(); // Call the new fetch method
  }

  // Fetch submissions with token
  void _fetchSubmissions() {
    final token = Provider.of<UserProvider>(context, listen: false).token;
    if (token != null) {
      setState(() {
        _submissionsFuture = SubmissionService.fetchSubmissionsByFormId(
          formId: widget.formId,
          token: token,
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User is not authenticated.')),
      );
    }
  }

  // Handle form submission
  Future<void> _handleSubmit(Map<String, dynamic> formData) async {
    final token = Provider.of<UserProvider>(context, listen: false).token;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User is not authenticated.')),
      );
      return;
    }

    try {
      await SubmissionService.submitFormData(
        formId: widget.formId,
        formData: formData,
        token: token,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form submitted successfully!')),
      );
      _fetchSubmissions(); // Refresh submissions after successful form submission
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit form.')),
      );
    }
  }

  // Handle submission deletion (admin-only feature)
  Future<void> _deleteSubmission(int submissionId) async {
    final token = Provider.of<UserProvider>(context, listen: false).token;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User is not authenticated.')),
      );
      return;
    }
    try {
      await SubmissionService.deleteSubmission(
        submissionId: submissionId,
        token: token,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Submission deleted successfully!')),
      );
      _fetchSubmissions(); // Refresh submissions after successful deletion
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete submission.')),
      );
    }
  }

  // Navigate to the FormScreen
  void _navigateToFormScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormScreen(formId: widget.formId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final role = userProvider.role;
    return Scaffold(
      appBar: AppBar(title: const Text('Submissions')),
      body: FutureBuilder<List<dynamic>>(
        future: _submissionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No submissions available.'));
          }

          final submissions = snapshot.data!;
          return ListView.builder(
            itemCount: submissions.length,
            itemBuilder: (context, index) {
              final submission = submissions[index];

              // Parse the 'data' field (which is already a map)
              Map<String, dynamic> parsedData = submission['data'];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                child: ListTile(
                  title: Text('Submission #${submission['id']}'),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: parsedData.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${formatKey(entry.key)}: ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${entry.value}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );

                      }).toList(),
                    ),
                  ),
                  trailing: role == 'admin'
                      ? IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _deleteSubmission(submission['id']);
                    },
                  )
                      : null,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToFormScreen,
        child: const Icon(Icons.add),
      ),
    );
  }
  String formatKey(String key) {
    return key
        .replaceAll('_', ' ') // Replace underscores with spaces
        .split(' ') // Split by space
        .map((word) => word[0].toUpperCase() + word.substring(1)) // Capitalize each word
        .join(' '); // Join words with spaces
  }

}
