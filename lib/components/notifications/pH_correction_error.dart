// ignore_for_file: file_names, library_private_types_in_public_api

import 'dart:async'; // Import for StreamSubscription
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class PhCorrectionErrorListener extends StatefulWidget {
  const PhCorrectionErrorListener({super.key});

  @override
  _PhCorrectionErrorListenerState createState() =>
      _PhCorrectionErrorListenerState();
}

class _PhCorrectionErrorListenerState extends State<PhCorrectionErrorListener> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('ERROR_CODES/phCorrection_ERROR');

  late StreamSubscription<DatabaseEvent> _subscription;

  @override
  void initState() {
    super.initState();
    _subscribeToDatabase();
  }

  void _subscribeToDatabase() {
    _subscription = _databaseReference.onValue.listen((DatabaseEvent event) {
      final String? value = event.snapshot.value?.toString();
      if (value == "201") {
        _showPhCorrectionErrorDialog(
          title: 'pH Alert',
          content: 'pH Level Critical',
        );
      } else if (value == "204") {
        _showPhCorrectionErrorDialog(
          title: 'pH Alert',
          content:
              'AQUAssist will initiate a 10% water change to optimize water quality. ',
        );
      } else if (value == "205") {
        _showPhCorrectionErrorDialog(
          title: "pH Alert",
          content:
              "AQUAssist will initiate another 15% water change to optimze water quality. System observations will follow. ",
        );
      } else if (value == "206") {
        _showPhCorrectionErrorDialog(
          title: "pH Level Critical",
          content:
              "AQUAssist will initiate another 15% water change to optimze water quality. System observations will follow.  ",
        );
      } else if (value == "207") {
        _showPhCorrectionErrorDialog(
          title: "pH Level Critical",
          content:
              "AQUAssist cannot optimize pH levels after 3 water corrective iterations. Please perform manual maintenance. ",
        );
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _showPhCorrectionErrorDialog(
      {required String title, required String content}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
