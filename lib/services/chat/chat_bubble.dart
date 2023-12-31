import 'package:flutter/material.dart';

// custom chat bubble
class ChatBubble extends StatelessWidget {
  // chat message to display
  final String message;
  // whether the message is special
  final bool isSpecial;
  const ChatBubble({super.key, required this.message, required this.isSpecial});

  @override
  Widget build(BuildContext context) {
    return Container(
      // decorations
      padding:const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        // red if special, blue if not
        color: isSpecial ? Colors.red: Colors.blue,
      ),
      child: Text(
        message,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}