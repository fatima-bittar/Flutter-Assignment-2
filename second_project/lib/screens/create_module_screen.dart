import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/module_service.dart';
import '../utils/auth_provider.dart';

class CreateFormScreen extends StatefulWidget {


  const CreateFormScreen({super.key});

  @override
  State<CreateFormScreen> createState() => _CreateFormScreenState();
}

class _CreateFormScreenState extends State<CreateFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _structureController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // if (widget.formId != null) {
    //   _loadFormData();
    // }
  }

  // Future<void> _loadFormData() async {
  //   final token = Provider.of<UserProvider>(context, listen: false).token;
  //   if (token == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('User is not authenticated.')),
  //     );
  //     return ;
  //   }
  //   try {
  //     final form = await FormService.fetchFormStructure(formId: widget.formId!, token: token);
  //     setState(() {
  //       _nameController.text = form?['name'] ?? '';
  //       _structureController.text = form?['structure'] ?? '';
  //     });
  //   } catch (error) {
  //     print('Error loading form: $error');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Failed to load form details.')),
  //     );
  //   }
  // }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      String structure = _structureController.text;

      try {
        // Parse the structure into a JSON object to validate it
        final parsedStructure = jsonDecode(structure); // Parse structure as JSON object
        print("Parsed Structure: $parsedStructure");

        final formData = {
          'name': _nameController.text,
          'structure': parsedStructure, // Send as JSON, not raw text
        };

        final token = Provider.of<UserProvider>(context, listen: false).token;
        if (token == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User is not authenticated.')),
          );
          return;
        }

        try {
          await FormService.addForm(formData: formData, token: token);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Module created successfully!')),
          );
          Navigator.pop(context);
        } catch (error) {
          print('Error saving form: $error');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to save form.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid JSON structure')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Module'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Module Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a module name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _structureController,
                decoration: const InputDecoration(labelText: 'Module Structure (JSON)'),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter module structure';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}