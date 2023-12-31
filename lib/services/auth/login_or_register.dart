import 'package:flutter/material.dart';
import 'package:bro/screens/loginPage.dart';
import 'package:bro/screens/registerPage.dart';

// toggle between the login and register pages
class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  // bool to determine whether to show login or register
  bool showLoginPage = true;

  // toggle
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    // show appropriate page based on bool
    if (showLoginPage) {
      return LoginPage(onTap: togglePages);
    }
    else {
      return RegisterPage(onTap: togglePages);
    }
  }
}