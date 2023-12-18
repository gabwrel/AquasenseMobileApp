// ignore_for_file: avoid_print, file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class MasterSwitchPage extends StatefulWidget {
  const MasterSwitchPage({super.key});

  @override
  State<MasterSwitchPage> createState() => _MasterSwitchPageState();
}

class _MasterSwitchPageState extends State<MasterSwitchPage> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('TRIGGERS');

  bool isActivated = false;

  @override
  void initState() {
    super.initState();
    _retrieveSwitchState();
  }

  void _retrieveSwitchState() {
    _databaseReference
        .child('TRIGGERS')
        .child('master_TRIGGER')
        .get()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        setState(() {
          isActivated = snapshot.value == '1';
        });
      }
    }).catchError((error) {
      // Handle errors if necessary
      print("Error retrieving switch state: $error");
    });
  }

  void _updateSwitchState(bool newValue) {
    int switchValue = newValue ? 1 : 0;
    _databaseReference
        .child('TRIGGERS')
        .child('master_TRIGGER')
        .set(switchValue.toString());
    setState(() {
      isActivated = newValue;
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
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/MASTERSWITCH.png',
                height: 250,
              ),
              const SizedBox(height: 16),
              const Text(
                'Warning: Turning off the entire system might cause problems in your growing tank',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.scale(
                    scale: 1,
                    child: CupertinoSwitch(
                      value: isActivated,
                      onChanged: (newValue) {
                        _updateSwitchState(newValue);
                      },
                      activeColor: Colors.blue, // Set the active color to blue
                      trackColor: Colors.grey, // Set the inactive color to grey
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
