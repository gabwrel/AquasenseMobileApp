import 'package:flutter/material.dart';
import 'package:aquasenseapp/database_helper.dart';

class StoredDataPage extends StatelessWidget {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance; // Use the named constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stored Data'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _databaseHelper.fetchAllData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return ListTile(
                  title: Text('pH: ${item['pH']}'),
                  subtitle: Text('Timestamp: ${item['timestamp']}'),
                  // Add more fields as needed
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
