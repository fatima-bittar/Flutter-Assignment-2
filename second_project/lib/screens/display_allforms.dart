import 'package:flutter/material.dart';
import '../services/form_service.dart';
import '../utils/database_helper.dart';
import 'form_screen.dart';

class DisplayAllForms extends StatefulWidget {
  const DisplayAllForms({super.key});

  @override
  State<DisplayAllForms> createState() => _DisplayAllFormsState();
}

class _DisplayAllFormsState extends State<DisplayAllForms> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Fetch all forms (either from API or local storage)
  Future<List<dynamic>> _fetchAllForms() async {
    try {
      // First, attempt to fetch forms from the local database
      final localForms = await _databaseHelper.fetchForms();

      if (localForms.isNotEmpty) {
        return localForms; // Return forms from local database if available
      } else {
        // If no forms in the local database, fetch from the API
        final forms = await FormService.fetchAllForms();

        // Save the fetched forms into the local database
        for (var form in forms) {
          await _databaseHelper.insertForm({
            'id': form['id'],
            'name': form['name'],
            'structure': form['structure'], // Save form structure as JSON string
          });
        }

        return forms; // Return the fetched forms from the API
      }
    } catch (error) {
      // Handle errors gracefully
      print('Error fetching forms: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch forms.')),
      );
      return []; // Return an empty list in case of an error
    }
  }

  // Method to handle form submission
  Future<void> _submitForm(int formId, Map<String, dynamic> formData) async {
    try {
      await _databaseHelper.insertSubmission({
        'form_id': formId,
        'data': formData,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form submitted successfully!')),
      );
    } catch (error) {
      print('Error submitting form: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit form data.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
            itemCount: forms.length,
            itemBuilder: (context, index) {
              final form = forms[index];
              return ListTile(
                title: Text(form['name'] ?? 'Unnamed Form'), // Provide a default value
                onTap: form['id'] != null
                    ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FormScreen(
                        formId: form['id'],
                      ),
                    ),
                  );
                }
                    : null, // Disable the tap if `id` is null
              );
            },
          );
        },
      ),
    );
  }
}
