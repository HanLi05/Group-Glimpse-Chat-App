import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({super.key, required this.onTap, required this.text});
  final void Function()? onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          // here
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          // here
          // border: Border.all(color: Colors.white, width: 2),
        ),
        child: Center(
          child: Text(
              text,
              style: const TextStyle(
                fontSize: 20,
                // here
                color: Color(0xFF1976D2),
                fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}