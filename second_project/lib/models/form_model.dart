class FormStructure {
  final int? id;
  final String name;
  final List<Field> fields;

  FormStructure({
    required this.id,
    required this.name,
    required this.fields,
  });

  // Factory to create FormStructure from JSON
  factory FormStructure.fromJson(Map<String, dynamic> json) {
    var fieldsList = (json['form'] as List)
        .map((field) => Field.fromJson(field))
        .toList();

    return FormStructure(
      id: json['id'],
      name: json['name'], // Assuming the API uses 'name' for the form title
      fields: fieldsList,
    );
  }

  // Convert FormStructure to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'structure': fields.map((field) => field.toJson()).toList(),
    };
  }
}

class Field {
  final String type;
  final String label;
  final String? placeholder;
  final bool required;
  final List<String>? options;

  Field({
    required this.type,
    required this.label,
    this.placeholder,
    required this.required,
    this.options,
  });

  // Factory to create Field from JSON
  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      type: json['type'],
      label: json['label'],
      placeholder: json['placeholder'],
      required: json['required'],
      options: (json['options'] as List?)?.map((e) => e as String).toList(),
    );
  }

  // Convert Field to JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'label': label,
      'placeholder': placeholder,
      'required': required,
      'options': options,
    };
  }
}
