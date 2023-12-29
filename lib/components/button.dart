import 'package:flutter/material.dart';

// custom button used in login and sign up pages
class MyButton extends StatelessWidget {
  const MyButton({super.key, required this.onTap, required this.text});
  // callback function executed when button is clicked
  final void Function()? onTap;
  // the text to be displayed on button
  final String text;

  @override
  Widget build(BuildContext context) {
    // handle tap gestures on button
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
              text,
              style: const TextStyle(
                fontSize: 20,
                color: Color(0xFF1976D2),
                fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}