import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database and create both forms and submissions tables
  _initDatabase() async {
    String path = join(await getDatabasesPath(), 'forms.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      // Create forms table
      await db.execute(
        '''CREATE TABLE forms (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          structure TEXT
        )''',
      );
      // Create submissions table
      await db.execute(
        '''CREATE TABLE submissions (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          form_id INTEGER,
          data TEXT,
          submission_date TEXT,
          FOREIGN KEY(form_id) REFERENCES forms(id)
        )''',
      );
    });
  }

  // Insert a new form into the local database
  Future<void> insertForm(Map<String, dynamic> form) async {
    final db = await database;
    try {
      form['structure'] = json.encode(form['structure']);  // Convert structure to JSON string
      await db.insert(
        'forms',
        form,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Form inserted: ${form['name']}');
    } catch (e) {
      print('Error inserting form: $e');
    }
  }

  // Insert a new submission into the local database
  Future<void> insertSubmission(Map<String, dynamic> submission) async {
    final db = await database;
    try {
      submission['data'] = json.encode(submission['data']);  // Serialize data to JSON string
      submission['submission_date'] = DateTime.now().toIso8601String();  // Add current date/time
      await db.insert(
        'submissions',
        submission,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Submission inserted');
    } catch (e) {
      print('Error inserting submission: $e');
    }
  }

  // Fetch all stored forms
  Future<List<Map<String, dynamic>>> fetchForms() async {
    final db = await database;
    final forms = await db.query('forms');
    return forms;
  }

  // Fetch form by id
  Future<Map<String, dynamic>?> fetchFormById(int id) async {
    final db = await database;

    // Query the database for the form with the specified id
    final result = await db.query(
      'forms',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return result.first; // Return the first matching result
    } else {
      return null; // Return null if no form is found
    }
  }

  // Fetch all stored submissions for a specific form
  Future<List<Map<String, dynamic>>> fetchSubmissionsByFormId(int formId) async {
    final db = await database;
    final submissions = await db.query(
      'submissions',
      where: 'form_id = ?',
      whereArgs: [formId],
    );
    return submissions;
  }

  // Delete all stored forms (for cleanup)
  Future<void> deleteForms() async {
    final db = await database;
    await db.delete('forms');
  }

  // Delete all stored submissions (for cleanup)
  Future<void> deleteSubmissions() async {
    final db = await database;
    await db.delete('submissions');
  }
}
