// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:aquasenseapp/main.dart';
import 'package:firebase_core/firebase_core.dart';

class MyEvent {
  final DataSnapshot snapshot;

  MyEvent(this.snapshot);
}

class WaterChangePage extends StatefulWidget {
  const WaterChangePage({super.key});

  @override
  _WaterChangePageState createState() => _WaterChangePageState();
}

class _WaterChangePageState extends State<WaterChangePage> {
  late StreamSubscription<MyEvent> _subscription;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    listenToValueChanges();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void listenToValueChanges() async {
    await Firebase.initializeApp();
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .ref()
        .child('TRIGGERS')
        .child('waterchange_TRIGGER');
    Stream<MyEvent> eventStream =
        databaseReference.onValue.map((event) => MyEvent(event.snapshot));
    _subscription = eventStream.listen((myEvent) {
      var value = myEvent.snapshot.value;
      if (value == null || value == '0') {
        setState(() {
          isLoading = false;
        });
        navigateToHome();
      }
    });
  }

  void navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );
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
            Navigator.pop(context);
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
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 150),
                  Image.asset(
                    'assets/images/aquassist.png',
                    height: 170,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Initializing Water Change',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 230),
                  isLoading
                      ? const SpinKitCircle(
                          color: Colors.red,
                          size: 70.0,
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
