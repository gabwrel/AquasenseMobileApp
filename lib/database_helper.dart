import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._();

  static const String tableName = 'stored_data';
  static const String columnId = 'id';
  static const String columnParameter = 'parameter';
  static const String columnValue = 'value';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    final String path = join(await getDatabasesPath(), 'stored_data.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) {
        return db.execute(
          '''
          CREATE TABLE $tableName(
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnParameter TEXT,
            $columnValue TEXT
          )
          ''',
        );
      },
    );
  }

  Future<int> insert(Map<String, dynamic> row) async {
    final Database db = await database;
    return await db.insert(tableName, row);
  }

  // Add other database operations as needed
}
