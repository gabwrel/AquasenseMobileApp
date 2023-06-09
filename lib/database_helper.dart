import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'my_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE sensor_data (
        id INTEGER PRIMARY KEY,
        parameter TEXT,
        value TEXT,
        dateTime TEXT
      )
    ''');
  }

  Future<List<Map<String, dynamic>>> fetchAllData() async {
    final Database db = await instance.database;
    return await db.query('sensor_data', orderBy: 'dateTime DESC');
  }

  Future<void> insert(Map<String, dynamic> data) async {
    final Database db = await instance.database;
    await db.insert('sensor_data', data);
  }
}
