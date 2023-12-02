import 'package:bro/main.dart';
import 'package:bro/screens/sendMessagePage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseNoti {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print(fCMToken);
    initPushNotifications();
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    navigatorKey.currentState?.pushNamed(
      '/notification_screen',
      arguments: message,
    );

    navigatorKey.currentState?.push(MaterialPageRoute(
      builder: (context) => SendMessagePage(),
    ));
  }


  Future initPushNotifications() async {
    //   FirebaseMessaging.onMessage.listen(handleMessage);
    //
    //   FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //     handleMessage(message);
    //   });
    //
    //   // Check if the app was opened by tapping the notification
    //   FirebaseMessaging.instance.getInitialMessage().then((message) {
    //     if (message != null) {
    //       handleMessage(message);
    //     }
    //   });
    // }

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}