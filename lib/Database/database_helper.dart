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
        id INTEGER PRIMARY KEY ,
        gender TEXT,
        weight INTEGER,
        wakeUpTime TEXT,
        sleepTime TEXT,
        dailyGoal INTEGER,
        selectedImage TEXT,
        selectedMl INTEGER
      )
    ''');

    await db.execute('''
   CREATE TABLE drink_logs(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      amount INTEGER,
      image TEXT,
      timestamp TEXT)
    ''');
  }

  Future<void> saveUserData({
    required String gender,
    required int weight,
    required int dailyGoal,
    required String wakeUp,
    required String sleep,
    String? selectedImage,
    int? selectedMl,
  }) async {
    final db = await database;

    await db.insert('user_data', {
      'id': 1, // Force it to always be ID 1
      'gender': gender,
      'weight': weight,
      'wakeUpTime': wakeUp,
      'sleepTime': sleep,
      'dailyGoal': dailyGoal,
      'selectedImage': selectedImage ?? 'assets/images/glass-water.png',
      'selectedMl': selectedMl ?? 100,
    }, conflictAlgorithm: ConflictAlgorithm.replace); // ✅ Overwrite row with ID = 1
  }



  Future<Map<String, dynamic>?> getUserData() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query('user_data');
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> updateSelectedMl(int ml) async {
    final db = await database;

    await db.update(
      'user_data',
      {'selectedMl': ml},
      where: 'id = ?',
      whereArgs: [1],
    );
  }
  Future<void> saveDrinkLog({
    required int amount,
    String? imagePath,
  }) async {
    final db = await database;

    await db.insert('drink_logs', {
      'amount': amount,
      'image': imagePath ?? 'assets/images/glass-water.png',
      'timestamp': DateTime.now().toIso8601String(),
    });

    print("Drink saved: $amount ml");
  }

  Future<int> getTodayDrinkTotal() async {
    final db = await database;

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayStartIso = todayStart.toIso8601String();

    final result = await db.rawQuery('''
    SELECT SUM(amount) as total FROM drink_logs 
    WHERE timestamp >= ?
  ''', [todayStartIso]);

    return (result.first['total'] as int?) ?? 0;
  }
  Future<bool> isTargetAchieved() async {
    final userData = await getUserData();
    final dailyGoal = userData?['dailyGoal'] ?? 2000;

    final totalDrank = await getTodayDrinkTotal();

    return totalDrank >= dailyGoal;
  }


  Future<void> debugPrintAllUserData() async {
    final db = await database;
    final result = await db.query('user_data');
    print("Current user_data rows: $result");
  }
  Future<void> updateGender(String gender) async {
    final db = await database;

    await db.update(
      'user_data',
      {'gender': gender},
      where: 'id = ?',
      whereArgs: [1], // Assuming only one row exists with id=1
    );
  }
  Future<void> updateDailyGoal(int newGoal) async {
    final db = await database;
    final rows = await db.update(
      'user_data',
      {'dailyGoal': newGoal},
      where: 'id = ?',
      whereArgs: [1],
    );

    print('Daily goal update -> $rows row(s) updated');
  }



}
