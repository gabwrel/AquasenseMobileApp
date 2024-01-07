import 'package:aquasenseapp/main.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

class TurbidityCorrection extends StatefulWidget {
  const TurbidityCorrection({super.key});

  @override
  State<TurbidityCorrection> createState() => _TurbidityCorrectionState();
}

class _TurbidityCorrectionState extends State<TurbidityCorrection> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance
      .ref()
      .child('ERROR_CODES/turbidityCorrection_ERROR');

  late StreamSubscription<DatabaseEvent> _subscription;

  @override
  void initState() {
    super.initState();
    _subscribeToDatabase();
  }

  void _subscribeToDatabase() {
    _subscription = _databaseReference.onValue.listen((DatabaseEvent event) {
      final String? value = event.snapshot.value?.toString();

      if (value == "301") {
        _showTubidityCorrectionDialog(
          title: "Turbidity Alert",
          content: "High Turbidity Levels!",
        );
      } else if (value == "302") {
        _showTubidityCorrectionDialog(
          title: "Water Turbidity High!",
          content:
              "AQUAssist will initiate a 15% water change to optimize water quality",
        );
      } else if (value == "303") {
        _showTubidityCorrectionDialog(
          title: "Water Turbidity High!",
          content:
              "AQUAssist will initiate another 15% water change to optimize water quality",
        );
      } else if (value == "304") {
        _showTubidityCorrectionDialog(
          title: "Water Turbidity High",
          content:
              "AQUAssist cannot optimize water turbidity after 2 water corrective iterations. Please perform manual maintenance",
          errorCode: "304", // Pass the errorCode as a parameter
        );
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _showTubidityCorrectionDialog(
      {required String title, required String content, String? errorCode}) {
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
            if (errorCode == "304")
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the current dialog
                  navigatorKey.currentState
                      ?.pushNamed('/dashboard/maintenance');
                },
                child: const Text('Go to AQUAssist'),
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
