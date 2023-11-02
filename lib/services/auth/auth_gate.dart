import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bro/screens/homePage.dart';
import 'package:bro/services/auth/login_or_register.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          return const LoginOrRegister();
          // if (snapshot.hasData) {
          //   return HomePage();
          // }
          // else {
          //   return const LoginOrRegister();
          // }
        },
      ),
    );
  }
}