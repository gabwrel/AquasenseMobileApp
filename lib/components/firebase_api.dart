import 'package:aquasenseapp/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// token : flR3WgI0R32aTr69xEQFe2:APA91bEXYTu7areWgQzHUl7vYUMhCko6AJWuxYyO87Y7Zt2NXktdiSPbuuIWX860xHyHqgBWvu47r17gHfFRIbHfNBGltU9xiuXRdagziHiSdWb1BS0k6iMHEDniE8q4_jMZCSbZGdCF

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    final data = message.data;
    if (data.containsKey('screen')) {
      final screen = data['screen'];
      navigatorKey.currentState?.pushNamed(screen);
    }
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
