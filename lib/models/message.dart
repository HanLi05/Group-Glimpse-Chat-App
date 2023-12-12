import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String senderUsername;
  final List<String> receiverId;
  final String message;
  final Timestamp timestamp;
  final bool special;

  Message({
    required this.senderId,
    required this.senderEmail,
    required this.senderUsername,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    required this.special,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'senderUsername': senderUsername,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
      'special': special,
    };
  }
}
