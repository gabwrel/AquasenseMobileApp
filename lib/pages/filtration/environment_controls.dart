// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EnvironementalControls extends StatefulWidget {
  const EnvironementalControls({Key? key});

  @override
  _EnvironementalControlsState createState() => _EnvironementalControlsState();
}

class _EnvironementalControlsState extends State<EnvironementalControls> {
  late DatabaseReference _databaseReference;
  late String lightingStatus = '';

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.ref();

    _databaseReference
        .child('TRIGGER')
        .child('lighting_TRIGGER')
        .onValue
        .listen((event) {
      setState(() {
        lightingStatus = event.snapshot.value?.toString() ?? '--';
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Icon and Text
                const Row(
                  children: [
                    Icon(
                      Icons.lightbulb,
                      color: Colors.yellow,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      "Lighting",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
                // Switch on the right
                const Spacer(),
                CupertinoSwitch(
                  value: lightingStatus == '1',
                  onChanged: (bool value) {
                    setState(() {
                      lightingStatus = value ? '1' : '0';
                      // Update the value in the Firebase Realtime Database
                      _databaseReference
                          .child('TRIGGER')
                          .child('lighting_TRIGGER')
                          .set(lightingStatus);
                    });
                  },
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  "Feeding",
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
