import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/responseform_model.dart';
import '../services/submissions_service.dart';
import '../services/form_service.dart';
import '../utils/auth_provider.dart';
import '../widgets/dynamic_form.dart';
import '../utils/database_helper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class FormScreen extends StatefulWidget {
  final int formId;

  const FormScreen({super.key, required this.formId});

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  FormStructure? formStructure;
  final Map<String, dynamic> formData = {};
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _fetchFormStructure();
  }

  // Checks if the device is online
  Future<bool> _isOnline() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  // Fetches the form structure based on the form ID
  Future<void> _fetchFormStructure() async {
    final token = Provider.of<UserProvider>(context, listen: false).token;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User is not authenticated.')),
      );
      return;
    }

    try {
      final data = await FormService.fetchFormStructure(formId: widget.formId, token: token);
      if (data != null && data.isNotEmpty) {
        setState(() {
          formStructure = FormStructure.fromJson(data);
        });
      } else {
        throw Exception('No data returned from API');
      }
    } catch (error) {
      print('Error fetching form structure: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch form structure.')),
      );
    }
  }

  // Submits the form data, checks if online or offline
  Future<void> _submitFormData() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields.')),
      );
      return;
    }

    final token = Provider.of<UserProvider>(context, listen: false).token;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User is not authenticated.')),
      );
      return;
    }

    try {
      bool online = await _isOnline();

      if (online) {
        if (formStructure != null && formStructure!.id != null) {
          await SubmissionService.submitFormData(
            formId: formStructure!.id!,
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
          'form_id': formStructure!.id!,
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
    return Scaffold(
      appBar: AppBar(
        title: Text(formStructure?.name ?? 'Form'),
      ),
      body: formStructure == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DynamicForm(
                formStructure: formStructure!,
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
