import 'package:flutter/material.dart';

// custom text field used in login and sign up pages
class MyTextField extends StatelessWidget {
  // controller for text inputs
  final TextEditingController controller;
  // hint text when field is empty
  final String hintText;
  // bool for whether text should be obscured (passwords)
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
});

  @override
  Widget build(BuildContext context) {
    // TextField for user input
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        // here
        fillColor: Colors.white,
        filled: true,
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF1976D2)),
      ),
    );
  }

}