class FormStructure {
  final int? id;
  final String name;
  final List<Field> fields;

  FormStructure({
    required this.id,
    required this.name,
    required this.fields,
  });

  factory FormStructure.fromJson(Map<String, dynamic> json) {
    // Parse the 'structure' key to extract 'fields'
    var fieldsList = (json['structure'] as List)
        .map((field) => Field.fromJson(field))
        .toList();

    return FormStructure(
      id: json['id'],
      name: json['name'],  // Assuming the API uses 'name' for the form title
      fields: fieldsList,
    );
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

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      type: json['type'],
      label: json['label'],
      placeholder: json['placeholder'],
      required: json['required'],
      options: (json['options'] as List?)?.map((e) => e as String).toList(),
    );
  }
}
