// ignore_for_file: avoid_print, file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ContinousDripPage extends StatefulWidget {
  const ContinousDripPage({Key? key}) : super(key: key);

  @override
  State<ContinousDripPage> createState() => _ContinousDripPageState();
}

class _ContinousDripPageState extends State<ContinousDripPage> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('FILTRATION_SYSTEM');

  bool isDripOn = false;

  @override
  void initState() {
    super.initState();
    _retrieveDripMode();
  }

  void _retrieveDripMode() {
    _databaseReference.child('drip_MODE').get().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        setState(() {
          isDripOn = snapshot.value == '1';
        });
      }
    }).catchError((error) {
      // Handle errors if necessary
      print("Error retrieving drip mode: $error");
    });
  }

  void _updateDripMode(bool newValue) {
    int dripValue = newValue ? 1 : 0;
    _databaseReference.child('drip_MODE').set(dripValue.toString());
    setState(() {
      isDripOn = newValue;
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
          padding: const EdgeInsets.all(22.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/Drip.png',
                height: 250,
              ),
              Image.asset(
                'assets/images/AboutThatDrip.png',
                height: 250,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.scale(
                    scale: 1,
                    child: CupertinoSwitch(
                      value: isDripOn,
                      onChanged: (newValue) {
                        _updateDripMode(newValue);
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
