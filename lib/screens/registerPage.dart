import 'package:bro/components/button.dart';
import 'package:bro/components/text_field.dart';
import 'package:flutter/material.dart';
import 'package:bro/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

// register page that creates an account for the user in firebase based on inputs
class RegisterPage extends StatefulWidget {
  // callback function when sign in link is clicked
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // controllers for email, password x2, and username
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final usernameController = TextEditingController();

  // sign up method
  void signUp() async {
    // error if passwords don't match
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Passwords do not match"),),);
    return;
    }
    // get auth service if passwords match
    final authService = Provider.of<AuthService>(context, listen:false);

    // call auth service method using controller inputs
    try {
      await authService.signUpWithEmailandPassword(emailController.text, passwordController.text, usernameController.text);
    }
    // catch and display errors
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),),);
    }
  }

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
                const Icon(
                  Icons.message,
                  size: 125,
                  color: Colors.white,
                ),

                const SizedBox(height: 10),

                const Text(
                  'Create an account!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 15),

                // username text field
                MyTextField(
                    controller: usernameController,
                    hintText: 'Username',
                    obscureText: false
                ),

                const SizedBox(height: 10),

                // email text field
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false
                ),

                const SizedBox(height: 10),

                // password text field
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // confirm password text field
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),

                const SizedBox(height: 15),

                MyButton(onTap: signUp, text: "Sign up"),

                const SizedBox(height: 15),

                // login in link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already a member?', style: TextStyle(color: Colors.white)),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login Now',
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