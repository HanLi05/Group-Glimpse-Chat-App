import 'package:bro/firebase_options.dart';
import 'package:bro/screens/sendMessagePage.dart';
import 'package:bro/services/auth/auth_gate.dart';
import 'package:bro/services/auth/auth_service.dart';
import 'package:bro/services/notification/firebase_noti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

final navigatorKey = GlobalKey<NavigatorState>();

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
      navigatorKey: navigatorKey,
      routes: {
        '/notification_screen':(context) => SendMessagePage(),
      }
    );
  }
}
