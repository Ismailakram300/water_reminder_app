import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();

  factory DatabaseHelper() => instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    Directory docsDir = await getApplicationDocumentsDirectory();
    String path = join(docsDir.path, 'user_data.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        gender TEXT,
        weight INTEGER,
        wakeUpTime TEXT,
        sleepTime TEXT
      )
    ''');
  }

  Future<void> saveUserData({
    required String gender,
    required int weight,
    required String wakeUp,
    required String sleep,
  }) async {
    final db = await database;
    await db.delete('user_data'); // Optional: only keep 1 record
    await db.insert('user_data', {
      'gender': gender,
      'weight': weight,
      'wakeUpTime': wakeUp,
      'sleepTime': sleep,
    });
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query('user_data');
    return result.isNotEmpty ? result.first : null;
  }
}
