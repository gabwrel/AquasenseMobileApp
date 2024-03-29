// ignore_for_file: library_private_types_in_public_api, unused_field

import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

class SystemErrorListener extends StatefulWidget {
  const SystemErrorListener({super.key});

  @override
  _SystemErrorListenerState createState() => _SystemErrorListenerState();
}

class _SystemErrorListenerState extends State<SystemErrorListener> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('NOTIFICATIONS/system_ERROR');

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
      if (value == "1") {
        _debounceSystemErrorAlert();
      }
    });
  }

  void _debounceSystemErrorAlert() {
    if (_debounceTimer != null && _debounceTimer!.isActive) {
      _debounceTimer!.cancel(); // Cancel the previous timer
    }

    _debounceTimer = Timer(const Duration(seconds: 5), () {
      _showSystemErrorAlert();
    });
  }

  void _showSystemErrorAlert() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'System Error',
      text: 'System failed to start',
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
