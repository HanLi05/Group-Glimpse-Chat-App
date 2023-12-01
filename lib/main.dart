import 'package:bro/firebase_options.dart';
import 'package:bro/services/auth/auth_gate.dart';
import 'package:bro/services/auth/auth_service.dart';
import 'package:bro/services/notification/firebase_noti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/homePage.dart';
// import './screens/homePageBackup.dart';
import './screens/loginPage.dart';
import './screens/registerPage.dart';
import './services/auth/login_or_register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseNoti().initNotifications();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xFF3E8EDE),
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
    );
  }
}
