import 'package:flutter/material.dart';
import '../models/responseform_model.dart';

class DynamicForm extends StatefulWidget {
  final FormStructure formStructure;
  final Map<String, dynamic> formData;

  const DynamicForm({
    super.key,
    required this.formStructure,
    required this.formData,
  });

  @override
  _DynamicFormState createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.formStructure.fields.map((field) {
        switch (field.type) {
          case 'text':
          case 'email':
            final controller = TextEditingController(
              text: widget.formData[field.label]?.toString() ?? '',
            );
            return TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: field.label,
                hintText: field.placeholder ?? '',
              ),
              keyboardType: field.type == 'email'
                  ? TextInputType.emailAddress
                  : TextInputType.text,
              validator: field.required
                  ? (value) {
                if (value == null || value.isEmpty) {
                  return '${field.label} is required';
                }
                return null;
              }
                  : null,
              onChanged: (value) {
                widget.formData[field.label] = value;
              },
            );

          case 'dropdown':
            return DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: field.label),
              value: widget.formData[field.label] as String?,
              items: field.options!
                  .map((option) => DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  widget.formData[field.label] = value;
                });
              },
              validator: field.required
                  ? (value) {
                if (value == null || value.isEmpty) {
                  return '${field.label} is required';
                }
                return null;
              }
                  : null,
            );
          case 'date':
            return GestureDetector(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );

                if (pickedDate != null) {
                  setState(() {
                    widget.formData[field.label] = pickedDate.toIso8601String();
                  });
                }
              },
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: field.label,
                    hintText: 'Select a date',
                  ),
                  controller: TextEditingController(
                    text: widget.formData[field.label] != null
                        ? DateTime.parse(widget.formData[field.label]).toLocal().toString().split(' ')[0]
                        : '',
                  ),
                  validator: field.required
                      ? (value) {
                    if (value == null || value.isEmpty) {
                      return '${field.label} is required';
                    }
                    return null;
                  }
                      : null,
                ),
              ),
            );


          case 'checkbox':
            return CheckboxListTile(
              title: Text(field.label),
              value: widget.formData[field.label] ?? false,
              onChanged: (value) {
                setState(() {
                  widget.formData[field.label] = value;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            );
          case 'radio':
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(field.label),
                ...field.options!.map((option) {
                  return RadioListTile<String>(
                    title: Text(option),
                    value: option,
                    groupValue: widget.formData[field.label],
                    onChanged: (value) {
                      setState(() {
                        widget.formData[field.label] = value;
                      });
                    },
                  );
                }).toList(),
              ],
            );
          default:
            return const SizedBox.shrink();
        }
      }).toList(),
    );
  }
}
