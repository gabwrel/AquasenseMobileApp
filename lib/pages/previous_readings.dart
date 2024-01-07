import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PreviousReadings extends StatefulWidget {
  const PreviousReadings({Key? key}) : super(key: key);

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
        duration: Duration(seconds: 3),
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
      columns: const [
        DataColumn(label: Text('Date')),
        DataColumn(label: Text('Time')),
        DataColumn(label: Text('ph Level')),
        DataColumn(label: Text('Turbidity (NTU)')),
        DataColumn(label: Text('Temperature (C)')),
      ],
      rows: readings
          .map(
            (reading) => DataRow(
              cells: [
                DataCell(Text(formatDate(reading['Date']))),
                DataCell(Text(formatTime(reading['Time']))),
                DataCell(Text(reading['ph Level'].toString())),
                DataCell(Text(reading['Turbidity (NTU)'].toString())),
                DataCell(Text(reading['Temperature (C)'].toString())),
              ],
            ),
          )
          .toList(),
    );
  }

  String formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String formatTime(String timeString) {
    DateTime time = DateTime.parse(timeString);
    return DateFormat('HH:mm:ss').format(time);
  }
}
