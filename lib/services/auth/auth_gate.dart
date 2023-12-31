import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bro/screens/homePage.dart';
import 'package:bro/services/auth/login_or_register.dart';

// listen for changes in auth
// if data in snapshot go to home, if not go to login/register
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance .authStateChanges(),
        builder: (context, snapshot) {
          // go to home if data in snapshot
          if (snapshot.hasData) {
            return const HomePage();
          }
          // otherwise go to login or register
          else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}