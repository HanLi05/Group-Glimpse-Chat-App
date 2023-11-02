import 'package:bro/components/button.dart';
import 'package:bro/components/text_field.dart';
import 'package:bro/services/auth/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signInWithEmailAndPassword(emailController.text, passwordController.text);
    }
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // here
      backgroundColor: const Color(0xFF1976D2),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const SizedBox(height: 50),

                Icon(
                  Icons.message,
                  size: 125,
                  // here
                  color: Colors.white,
                ),

                const SizedBox(height: 10),

                const Text(
                  'Welcome back!',
                  style: TextStyle(
                    fontSize: 16,
                    // here (delete line)
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 30),

                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false
                ),

                const SizedBox(height: 15),

                MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                ),

                const SizedBox(height: 15),

                MyButton(onTap: signIn, text: "Sign in"),

                const SizedBox(height: 20),

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