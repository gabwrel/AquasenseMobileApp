// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class FiltrationSystemPage extends StatefulWidget {
  const FiltrationSystemPage({super.key});

  @override
  _FiltrationSystemPageState createState() => _FiltrationSystemPageState();
}

class _FiltrationSystemPageState extends State<FiltrationSystemPage> {
  late DatabaseReference _databaseReference;
  late String uvStatus;
  late String filtrationStatus;

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.ref();

    // Retrieve UV Lamp status from Firebase
    _databaseReference
        .child('FILTRATION_SYSTEM')
        .child('uvLamp_TRIGGER')
        .onValue
        .listen((event) {
      setState(() {
        uvStatus = event.snapshot.value?.toString() ?? '--';
      });
    });

    // Retrieve Filtration System status from Firebase
    _databaseReference
        .child('FILTRATION_SYSTEM')
        .child('filtrationsystem_MODE')
        .onValue
        .listen((event) {
      setState(() {
        filtrationStatus = event.snapshot.value?.toString() ?? '--';
      });
    });
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
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final availableHeight = constraints.maxHeight;

            return SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset('assets/images/filtration.png',
                      height: availableHeight * 0.4),
                  SizedBox(height: availableHeight * 0.05),
                  buildCardRow('UV Lamp', 'uvLamp_TRIGGER', uvStatus),
                  buildCardRow('Filtration System', 'filtrationsystem_MODE',
                      filtrationStatus),
                  buildCardRow('Environment Control', 'environment_MODE',
                      '--'), // Replace '--' with actual data when available
                  // Add more widgets here as needed
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildCardRow(String title, String databaseKey, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 4.0,
        child: ListTile(
          title: Text(title),
          leading: const Icon(Icons.settings),
          trailing: Switch(
            value: status == '1',
            onChanged: (newValue) {
              // Update the switch value in the Firebase Realtime Database
              _databaseReference
                  .child('FILTRATION_SYSTEM')
                  .child(databaseKey)
                  .set(newValue ? "1" : "0");
            },
          ),
        ),
      ),
    );
  }
}
