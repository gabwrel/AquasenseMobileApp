// ignore_for_file: unused_field

import 'package:aquasenseapp/main.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:quickalert/quickalert.dart';

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
  bool _isAlertShown = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _subscribeToDatabase();
  }

  void _subscribeToDatabase() {
    _subscription = _databaseReference.onValue.listen((DatabaseEvent event) {
      final String? value = event.snapshot.value?.toString();

      if (value == "301") {
        _debounceTurbidityCorrectionAlert(
          title: "Turbidity Alert",
          content: "High Turbidity Levels!",
        );
      } else if (value == "302") {
        _debounceTurbidityCorrectionAlert(
          title: "Water Turbidity High!",
          content:
              "AQUAssist will initiate a 15% water change to optimize water quality",
        );
      } else if (value == "303") {
        _debounceTurbidityCorrectionAlert(
          title: "Water Turbidity High!",
          content:
              "AQUAssist will initiate another 15% water change to optimize water quality",
        );
      } else if (value == "304") {
        _debounceTurbidityCorrectionAlert(
          title: "Water Turbidity High",
          content:
              "AQUAssist cannot optimize water turbidity after 2 water corrective iterations. Please perform manual maintenance",
          errorCode: "304", // Pass the errorCode as a parameter
        );
      }
    });
  }

  void _debounceTurbidityCorrectionAlert(
      {required String title, required String content, String? errorCode}) {
    if (_debounceTimer != null && _debounceTimer!.isActive) {
      _debounceTimer!.cancel(); // Cancel the previous timer
    }

    _debounceTimer = Timer(const Duration(seconds: 1), () {
      _showTurbidityCorrectionAlert(
        title: title,
        content: content,
        errorCode: errorCode,
      );
    });
  }

  void _showTurbidityCorrectionAlert(
      {required String title, required String content, String? errorCode}) {
    if (errorCode == "304") {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: title,
        text: content,
        confirmBtnText: 'Open AQUAssist',
        onConfirmBtnTap: () {
          _isAlertShown = false; // Reset the flag when the alert is dismissed
          Navigator.of(context).pop(); // Close the current alert
          navigatorKey.currentState?.pushNamed('/dashboard/maintenance');
        },
      );
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: title,
        text: content,
        confirmBtnText: 'OK',
        onConfirmBtnTap: () {
          _isAlertShown = false; // Reset the flag when the alert is dismissed
          Navigator.of(context).pop(); // Close the current alert
        },
      );
    }
    _isAlertShown = true; // Set the flag to indicate that the alert is open
  }

  @override
  void dispose() {
    _subscription.cancel();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
