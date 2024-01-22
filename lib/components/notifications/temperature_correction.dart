// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

class TemperatureCorrectionListener extends StatefulWidget {
  const TemperatureCorrectionListener({super.key});

  @override
  State<TemperatureCorrectionListener> createState() =>
      _TemperatureCorrectionListenerState();
}

class _TemperatureCorrectionListenerState
    extends State<TemperatureCorrectionListener> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('ERROR_CODES/temperature_ERROR');

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
      if (value == "401") {
        _debounceTemperatureAlert(
          title: 'Water Temperature Alert',
          content: 'Water Temperature Critical',
        );
      } else if (value == '402') {
        _debounceTemperatureAlert(
          title: 'Water Temperature Alert',
          content: 'Low Temperature! AQUAssist will now activate heater.',
        );
      } else if (value == '403') {
        _debounceTemperatureAlert(
          title: 'Water Temperature Alert',
          content: 'High Temperature! AQUAssist will now deactivate heater.',
        );
      }
    });
  }

  void _debounceTemperatureAlert(
      {required String title, required String content}) {
    if (_debounceTimer != null && _debounceTimer!.isActive) {
      _debounceTimer!.cancel(); // Cancel the previous timer
    }

    _debounceTimer = Timer(const Duration(seconds: 5), () {
      _showTemperatureErrorAlert(title: title, content: content);
    });
  }

  void _showTemperatureErrorAlert(
      {required String title, required String content}) {
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
