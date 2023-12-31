import 'package:cloud_firestore/cloud_firestore.dart';

// message object to get pushed to firebase database
class Message {
  final String senderId;
  final String senderEmail;
  final String senderUsername;
  // list of strings containing all receiver ids
  final List<String> receiverId;
  final String message;
  final Timestamp timestamp;
  // whether or not the message is a group glimpse special message
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

  // convert message object to map for storing
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
