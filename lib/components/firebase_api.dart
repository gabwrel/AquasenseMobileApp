// ignore_for_file: avoid_print

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final databaseReference = FirebaseDatabase.instance.ref();

  void handleMessage(RemoteMessage? message, BuildContext context) {
    if (message == null) return;

    final notification = message.notification;
    if (notification != null) {
      print('Title: ${notification.title}');
      print('Body: ${notification.body}');

      // Show dialog only when the app is in the foreground
      if (MediaQuery.of(context).size.width > 0 &&
          MediaQuery.of(context).size.height > 0) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(notification.title ?? 'Notification'),
              content: Text(notification.body ?? ''),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }

    // Handle the incoming FCM message when the app is in the foreground
    print('FCM Message Received: ${message.data}');
    // Perform custom actions based on the message data
  }

  Future<void> initPushNotifications(BuildContext context) async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await FirebaseMessaging.instance.subscribeToTopic('all');

    FirebaseMessaging.onMessage.listen((message) {
      // Check if the app is in the foreground before handling the message
      if (MediaQuery.of(context).size.width > 0 &&
          MediaQuery.of(context).size.height > 0) {
        handleMessage(message, context);
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        // Check if the app is in the foreground before handling the initial message
        if (MediaQuery.of(context).size.width > 0 &&
            MediaQuery.of(context).size.height > 0) {
          handleMessage(message, context);
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // Check if the app is in the foreground before handling the opened app message
      if (MediaQuery.of(context).size.width > 0 &&
          MediaQuery.of(context).size.height > 0) {
        handleMessage(message, context);
      }
    });
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    // Get the current FCM token
    final currentToken = await _firebaseMessaging.getToken();
    print('Token: $currentToken');

    // Save the current FCM token to the database
    await saveTokenToDatabase(currentToken!);

    // Listen for token refresh events
    _firebaseMessaging.onTokenRefresh.listen((String? newToken) async {
      if (newToken != null) {
        // Save the updated FCM token to the database
        await saveTokenToDatabase(newToken);
      }
    });

    // Set up background message handling
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  Future<void> saveTokenToDatabase(String token) async {
    try {
      await databaseReference.child('fcm-token/$token').set({
        'token': token,
      });
    } catch (e) {
      print('Error saving token to the database: $e');
      // Handle the error as needed
    }
  }

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    print('Handling background message:');
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
    print('Payload: ${message.data}');
  }

  // New method to trigger system error notification
}
