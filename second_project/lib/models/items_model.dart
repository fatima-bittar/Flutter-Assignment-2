class Submission {
  final int id;
  final int formId;
  final Map<String, dynamic> data;

  Submission({required this.id, required this.formId, required this.data});

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      id: json['id'],
      formId: json['form_id'],
      data: json['data'],
    );
  }
}
