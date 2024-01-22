// ignore_for_file: file_names, library_private_types_in_public_api, unused_field

import 'package:aquasenseapp/main.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart'; // Import the QuickAlert package
import 'dart:async';
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
      if (value == "201") {
        _debounceDialog(
          title: 'pH Alert',
          content: 'pH Level Critical',
        );
      } else if (value == "204") {
        _debounceDialog(
          title: 'pH Alert',
          content:
              'AQUAssist will initiate a 10% water change to optimize water quality. ',
        );
      } else if (value == "205") {
        _debounceDialog(
          title: "pH Alert",
          content:
              "AQUAssist will initiate another 15% water change to optimize water quality. System observations will follow. ",
        );
      } else if (value == "206") {
        _debounceDialog(
          title: "pH Level Critical",
          content:
              "AQUAssist will initiate another 15% water change to optimize water quality. System observations will follow.  ",
        );
      } else if (value == "207") {
        _debounceDialog(
          title: "pH Level Critical",
          content:
              "AQUAssist cannot optimize pH levels after 3 water corrective iterations. Please perform manual maintenance. ",
          errorCode: "207",
        );
      }
    });
  }

  void _debounceDialog(
      {required String title, required String content, String? errorCode}) {
    if (_debounceTimer != null && _debounceTimer!.isActive) {
      _debounceTimer!.cancel(); // Cancel the previous timer
    }

    _debounceTimer = Timer(const Duration(seconds: 1), () {
      _showPhCorrectionErrorAlert(
        title: title,
        content: content,
        errorCode: errorCode,
      );
    });
  }

  void _showPhCorrectionErrorAlert(
      {required String title, required String content, String? errorCode}) {
    if (errorCode == "207") {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: title,
        text: content,
        confirmBtnText: 'OK',
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
            _isAlertShown = false;
            Navigator.of(context).pop();
          });
    }
    _isAlertShown = true;
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
