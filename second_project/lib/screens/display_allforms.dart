import 'package:flutter/material.dart';
import '../services/form_service.dart';
import 'form_screen.dart';

class DisplayAllForms extends StatefulWidget {
  const DisplayAllForms({super.key});

  @override
  State<DisplayAllForms> createState() => _DisplayAllFormsState();
}

class _DisplayAllFormsState extends State<DisplayAllForms> {
  Future<List<dynamic>> _fetchAllForms() async {
    try {
      // Fetch forms from the service
      final forms = await FormService.fetchAllForms();
      return forms; // Return the fetched forms
    } catch (error) {
      // Handle errors gracefully
      print('Error fetching forms: $error');
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch forms.')),
      );
      return []; // Return an empty list in case of an error
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
          print(snapshot.data!);
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
                      builder: (context) => FormScreen(formId: form['id']),
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
