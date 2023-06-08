import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'my_database.db');

    Database database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE previous_readings ('
          'id INTEGER PRIMARY KEY, '
          'date TEXT, '
          'time TEXT, '
          'pH REAL, '
          'waterTemp REAL, '
          'waterTurbidity REAL, '
          'waterLevel REAL, '
          'timestamp INTEGER'
          ')',
        );
      },
    );

    return database;
  }

  Future<void> insertReading(Map<String, dynamic> reading) async {
    final db = await database;
    await db.insert(
      'previous_readings',
      reading,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getData() async {
    try {
      final db = await database;
      final dataList = await db.query('previous_readings', orderBy: 'timestamp DESC');
      return dataList;
    } catch (e) {
      print('Error retrieving data from the database: $e');
      throw Exception('Failed to retrieve data');
    }
  }
}

class PreviousReadingsPage extends StatefulWidget {
  @override
  _PreviousReadingsPageState createState() => _PreviousReadingsPageState();
}

class _PreviousReadingsPageState extends State<PreviousReadingsPage> {
  final dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Previous Readings'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbHelper.getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No previous readings found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final reading = snapshot.data![index];
                final date = reading['date'] as String;
                final time = reading['time'] as String;
                final pH = double.tryParse(reading['pH']) ?? 0;
                final waterTemp = double.tryParse(reading['waterTemp']) ?? 0;
                final waterTurbidity = double.tryParse(reading['waterTurbidity']) ?? 0;
                final waterLevel = double.tryParse(reading['waterLevel']) ?? 0;

                return ListTile(
                  title: Text('Date: $date'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Time: $time'),
                      Text('pH: ${pH.toStringAsFixed(2)}'),
                      Text('Water Temperature: ${waterTemp.toStringAsFixed(2)}'),
                      Text('Water Turbidity: ${waterTurbidity.toStringAsFixed(2)}'),
                      Text('Water Level: ${waterLevel.toStringAsFixed(2)}'),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
