import 'package:bro/main.dart';
import 'package:bro/screens/sendMessagePage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseNoti {
  // instance of firebase messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // init push notifications
  Future<void> initNotifications() async {
    // request device for permissions for notifications
    await _firebaseMessaging.requestPermission();

    // get fCM token
    final fCMToken = await _firebaseMessaging.getToken();
    print(fCMToken);
    initPushNotifications();
  }

  // handle incoming messages - send to send message page
  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    navigatorKey.currentState?.pushNamed(
      '/notification_screen',
      arguments: message,
    );

    // send to send message page
    navigatorKey.currentState?.push(MaterialPageRoute(
      builder: (context) => SendMessagePage(),
    ));
  }


  Future initPushNotifications() async {
    // handle when app opened from terminated state
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    // listen for messages when app is in foreground
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}