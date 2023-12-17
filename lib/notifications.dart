// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    initializeNotifications();
    initializeFirebaseMessaging();
    checkPHDifference();
  }

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Handle notification selection
        // You can use response.notification to get information about the notification
      },
    );
  }

  Future<void> initializeFirebaseMessaging() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle incoming FCM messages when the app is in the foreground
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle notification tap when the app is in the background
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _firebaseMessaging.subscribeToTopic('all'); // Subscribe to a topic
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // Handle background FCM messages
  }

  Future<void> checkPHDifference() async {
    // Fetch pH value from Firebase
    double? ph = await fetchFirebaseValue('SENSOR_DATA/ph');

    // Fetch phConfig value from Firebase
    double? phConfig = await fetchFirebaseValue('PARAMETERS_CONFIG/ph_CONFIG');

    if (ph != null && phConfig != null) {
      double pHDifference = (ph - phConfig).abs();

      if (pHDifference > 2) {
        showNotification();
      }
    }
  }

  Future<double?> fetchFirebaseValue(String path) async {
    DatabaseEvent event = await databaseRef.child(path).once();
    // Use event.snapshot instead of snapshot
    return event.snapshot != null
        ? double.parse(event.snapshot.value.toString())
        : null;
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Warning!',
      'pH levels are critical!',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
