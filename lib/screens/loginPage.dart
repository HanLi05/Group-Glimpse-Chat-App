import 'package:bro/components/button.dart';
import 'package:bro/components/text_field.dart';
import 'package:bro/services/auth/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

// login page
class LoginPage extends StatefulWidget {
  // callback function when register now link is clicked
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // controllers for email and password text fields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign in function
  void signIn() async {
    // access auth service
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      // call sign in method from auth service using user inputs for username and password
      await authService.signInWithEmailAndPassword(emailController.text, passwordController.text);
    }
    catch (e) {
      // handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  // build UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1976D2),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Group Glimpse',
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                Icon(
                  Icons.message,
                  size: 125,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Welcome back!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                // custom text field for entering email
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false
                ),
                const SizedBox(height: 15),
                // custom text field for entering password
                MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                ),
                const SizedBox(height: 15),
                // custom button for signing in
                MyButton(onTap: signIn, text: "Sign in"),
                const SizedBox(height: 20),
                // not a member message with register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Not a member?', style: TextStyle(color: Colors.white)),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Register Now',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}