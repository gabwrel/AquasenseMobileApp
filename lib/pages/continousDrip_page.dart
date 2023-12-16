// ignore_for_file: file_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ContinousDripPage extends StatefulWidget {
  const ContinousDripPage({super.key});

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
    _databaseReference.child('drip_MODE').once().then((DataSnapshot snapshot) {
          if (snapshot.value != null) {
            setState(() {
              isDripOn = snapshot.value == '1';
            });
          }
        } as FutureOr Function(DatabaseEvent value));
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
        elevation: 2,
        toolbarHeight: 80,
        backgroundColor: Colors.white,
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
          const Text(
            "Upgrade your aquarium care with the Continuous Drip feature! This innovative system allows for a gradual introduction of new water, ensuring a stress-free environment for your aquatic friends. Ideal for acclimating new arrivals, stabilizing water parameters, and promoting overall aquarium health. Experience the benefits of controlled water changes with ease!",
          ),
          Row(
            children: [
              const Text("Continuous Drip"),
              Switch(
                value: isDripOn,
                onChanged: (newValue) {
                  _updateDripMode(newValue);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
