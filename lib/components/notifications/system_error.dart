// ignore_for_file: library_private_types_in_public_api

import 'dart:async'; // Import for StreamSubscription
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _subscribeToDatabase();
  }

  void _subscribeToDatabase() {
    _subscription = _databaseReference.onValue.listen((DatabaseEvent event) {
      // Check the value when it changes
      final String? value = event.snapshot.value?.toString();
      if (value == "1") {
        _showErrorDialog();
      }
    });
  }

  @override
  void dispose() {
    // Cancel the subscription when the widget is disposed
    _subscription.cancel();
    super.dispose();
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('System Error'),
          content: const Text('System failed to start'),
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
    // You can customize this widget further if needed
    return Container();
  }
}
