import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
// import 'package:fl_chart/fl_chart.dart';

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
    final response = await http.get(
      Uri.parse(
        'https://script.google.com/macros/s/AKfycbwiyxXB3ny8t67gYn57XMadsmql5IYdD_Q5Jvm3TYDnY246U9P6XBbM_zI2dQRGHX2xnQ/exec',
      ),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        readings = List<Map<String, dynamic>>.from(data);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  String formatDateTime(String dateTimeString) {
    // Parse the string to a DateTime object
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Format the DateTime as per your requirements
    String formattedDateTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);

    return formattedDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('assets/images/PreviousReadings.png'),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Date and Time')),
                      DataColumn(label: Text('pH Level')),
                      DataColumn(label: Text('Temperature')),
                      DataColumn(label: Text('Water Turbidity')),
                    ],
                    rows: readings.map((reading) {
                      return DataRow(
                        cells: [
                          DataCell(
                              Text(formatDateTime(reading['DateAndTime']))),
                          DataCell(Text(reading['pHLevel'].toString())),
                          DataCell(Text(reading['temperature'].toString())),
                          DataCell(Text(reading['waterTurbidity'].toString())),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
