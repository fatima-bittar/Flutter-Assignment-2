import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/form_service.dart';
import '../utils/auth_provider.dart';

class CreateEditFormScreen extends StatefulWidget {
  final int? formId;

  const CreateEditFormScreen({super.key, this.formId});

  @override
  State<CreateEditFormScreen> createState() => _CreateEditFormScreenState();
}

class _CreateEditFormScreenState extends State<CreateEditFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _structureController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.formId != null) {
      _loadFormData();
    }
  }

  Future<void> _loadFormData() async {
    final token = Provider.of<UserProvider>(context, listen: false).token;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User is not authenticated.')),
      );
      return ;
    }
    try {
      final form = await FormService.fetchFormStructure(formId: widget.formId!, token: token);
      setState(() {
        _nameController.text = form?['name'] ?? '';
        _structureController.text = form?['structure'] ?? '';
      });
    } catch (error) {
      print('Error loading form: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load form details.')),
      );
    }
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      final formData = {
        'name': _nameController.text,
        'structure': _structureController.text,
      };
      final token = Provider.of<UserProvider>(context, listen: false).token;
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User is not authenticated.')),
        );
        return ;
      }
      try {
        if (widget.formId == null) {
          await FormService.addForm(formData: formData, token: token);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Form created successfully!')),
          );
        } else {
          await FormService.editForm(formId: widget.formId!,formData:  formData, token:token);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Form updated successfully!')),
          );
        }
        Navigator.pop(context);
      } catch (error) {
        print('Error saving form: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save form.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.formId == null ? 'Create Form' : 'Edit Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Form Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a form name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _structureController,
                decoration: const InputDecoration(labelText: 'Form Structure (JSON)'),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter form structure';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text(widget.formId == null ? 'Create' : 'Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
