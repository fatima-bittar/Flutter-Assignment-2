import 'package:flutter/material.dart';
import '../models/responseform_model.dart';
import '../services/form_service.dart';
import '../widgets/dynamic_form.dart';


class FormScreen extends StatefulWidget {
  final int formId; // Accept formId as a required parameter
  const FormScreen({super.key, required this.formId});

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  FormStructure? formStructure;
  final Map<String, dynamic> formData = {};
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchFormStructure();
  }

  Future<void> _fetchFormStructure() async {
    try {
      final data = await FormService.fetchFormStructure(widget.formId);
      print('Fetched data: $data');
      if (data != null && data.isNotEmpty ) {

        setState(() {
          formStructure = FormStructure.fromJson(data);
        });
      }
      else {
        throw Exception('No data returned from API');
      }
    } catch (error) {
      print('Error fetching form structure: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch form structure.')),
      );
    }
  }

  Future<void> _submitFormData() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields.')),
      );
      return;
    }
    print('hello before $formData');
    try {
      await FormService.submitFormData(formStructure!.id, formData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form submitted successfully!')),
      );

      setState(() {
        formData.clear(); // Clears the form data and triggers UI rebuild
      });
      print('hello after $formData');
    } catch (error) {
      print('Error in _submitFormData: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit form data.')),
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
          : Padding(
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
