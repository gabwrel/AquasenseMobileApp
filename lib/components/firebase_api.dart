// ignore_for_file: avoid_print

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final databaseReference = FirebaseDatabase.instance.ref();

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    final notification = message.notification;
    if (notification != null) {
      print('Title: ${notification.title}');
      print('Body: ${notification.body}');
      // Handle the notification as needed, without navigating to a screen
    }

    // Handle the incoming FCM message when the app is in the foreground
    print('FCM Message Received: ${message.data}');
    // Perform custom actions based on the message data
  }

  Future<void> initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await FirebaseMessaging.instance.subscribeToTopic('all');

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
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
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
    print('Payload: ${message.data}');
  }
}
