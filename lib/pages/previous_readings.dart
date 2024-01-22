// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PreviousReadings extends StatefulWidget {
  const PreviousReadings({super.key});

  @override
  State<PreviousReadings> createState() => _PreviousReadingsState();
}

class _PreviousReadingsState extends State<PreviousReadings> {
  List<Map<String, dynamic>> readings = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://script.google.com/macros/s/AKfycbwJuWDd9UV-53FuV5kUJYcQodL7zF5PFBcA7qwVJl-L2pHlV6t8h1-B73Et5q79fkbhlg/exec',
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          readings = List<Map<String, dynamic>>.from(data);
        });
      } else {
        showErrorSnackbar('Failed to load data');
      }
    } catch (error) {
      showErrorSnackbar('An error occurred: $error');
    }
  }

  void showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      toolbarHeight: 80,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.blue),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/dashboard');
        },
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(child: Container()),
          Image.asset(
            'assets/images/logo2.png',
            height: 60,
          ),
        ],
      ),
    );
  }

  Widget buildBody() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/images/PreviousReadings.png'),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: buildDataTable(),
            ),
          ],
        ),
      ),
    );
  }

  DataTable buildDataTable() {
    return DataTable(
      columnSpacing: 10.0, // Adjust the spacing between columns
      headingRowHeight: 40.0, // Adjust the height of the heading row
      dataRowHeight: 35.0, // Adjust the height of data rows
      columns: const [
        DataColumn(label: Text('Date')),
        DataColumn(label: Text('pH Level')),
        DataColumn(label: Text('Turbidity (NTU)')),
        DataColumn(label: Text('Temperature (C)')),
      ],
      rows: readings
          .map(
            (reading) => DataRow(
              cells: [
                DataCell(
                  Center(
                    child: Text(
                      formatDate(reading['Date']),
                      style: const TextStyle(fontSize: 14.0),
                    ),
                  ),
                ),
                DataCell(
                  Center(
                    child: Text(
                      reading['ph Level'].toString(),
                      style: const TextStyle(fontSize: 14.0),
                    ),
                  ),
                ),
                DataCell(
                  Center(
                    child: Text(
                      reading['Turbidity (NTU)'].toString(),
                      style: const TextStyle(fontSize: 14.0),
                    ),
                  ),
                ),
                DataCell(
                  Center(
                    child: Text(
                      reading['Temperature (C)'].toString(),
                      style: const TextStyle(fontSize: 14.0),
                    ),
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}

String formatDate(String dateString) {
  DateTime date = DateTime.parse(dateString);
  return DateFormat('yyyy-MM-dd').format(date);
}

String formatTime(String timeString) {
  DateTime time = DateTime.parse(timeString);
  return DateFormat('HH:mm:ss').format(time);
}
