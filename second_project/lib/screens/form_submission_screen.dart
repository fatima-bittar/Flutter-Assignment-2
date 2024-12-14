import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/responseform_model.dart';
import '../services/submissions_service.dart';
import '../utils/auth_provider.dart';
import '../widgets/dynamic_form_submission.dart';
import '../utils/database_helper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class FormSubmissionScreen extends StatefulWidget {
  final Map<String, dynamic> form; // Accept the full form object

  const FormSubmissionScreen({super.key, required this.form});

  @override
  _FormSubmissionScreenState createState() => _FormSubmissionScreenState();
}

class _FormSubmissionScreenState extends State<FormSubmissionScreen> {
  late Map<String, dynamic> form;
  late FormStructure formStructure; // Declare FormStructure
  final Map<String, dynamic> formData = {};
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    form = widget.form;

    // Parse form['structure'] into FormStructure
    formStructure = FormStructure.fromJson(form);
  }

  // Checks if the device is online
  Future<bool> _isOnline() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  // Submits the form data, checks if online or offline
  Future<void> _submitFormData() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields.')),
      );
      return;
    }

    final token = Provider
        .of<UserProvider>(context, listen: false)
        .token;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User is not authenticated.')),
      );
      return;
    }

    try {
      bool online = await _isOnline();

      if (online) {
        if (form['id'] != null) {
          await SubmissionService.submitFormData(
            formId: form['id'],
            formData: formData,
            token: token,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Form submitted successfully!')),
          );

          setState(() {
            formData.clear();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Form ID is missing.')),
          );
        }
      } else {
        await _databaseHelper.insertSubmission({
          'form_id': form['id'],
          'data': formData,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You are offline. Form saved locally.')),
        );

        setState(() {
          formData.clear();
        });
      }
    } catch (error) {
      print('Error in _submitFormData: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit form data: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final form = widget.form;

    if (form['structure'] == null || form['structure'].isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(form['name'] ?? 'Form'),
        ),
        body: const Center(
          child: Text('Failed to load form structure.'),
        ),
      );
    }

    // Parse the structure into a FormStructure object
    final formStructure = FormStructure.fromJson({
      'id': form['id'],
      'name': form['name'],
      'structure': form['structure'],
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(formStructure.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DynamicForm(
                formStructure: formStructure,
                // Pass fields to DynamicForm
                formData: formData,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitFormData,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}