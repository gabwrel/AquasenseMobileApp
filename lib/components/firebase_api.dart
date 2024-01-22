// ignore_for_file: avoid_print

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final databaseReference = FirebaseDatabase.instance.ref();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message, BuildContext context) async {
    if (message == null) return;

    final notification = message.notification;
    if (notification != null) {
      print('Title: ${notification.title}');
      print('Body: ${notification.body}');

      // Show system notification
      await showSystemNotification(
        title: notification.title ?? 'Notification',
        body: notification.body ?? '',
      );
    }

    // Handle the incoming FCM message
    print('FCM Message Received: ${message.data}');
    // Perform custom actions based on the message data
  }

  Future<void> showSystemNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'com.example.aquasenseapp.notification_channel', // Replace with your unique channel ID
      'AquaSense Notifications',
      channelDescription: 'Channel for AquaSense notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0, // Change this to a unique ID for each notification
      title,
      body,
      platformChannelSpecifics,
    );
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
      // Handle the message uniformly regardless of the app's state
      handleMessage(message, context);
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      // Handle the initial message uniformly regardless of the app's state
      if (message != null) {
        handleMessage(message, context);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // Handle the message uniformly regardless of the app's state
      handleMessage(message, context);
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
