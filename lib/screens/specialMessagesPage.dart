import 'package:bro/components/text_field.dart';
import 'package:bro/screens/specialMessagesPage.dart';
import 'package:bro/services/chat/chat_bubble.dart';
import 'package:bro/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../testing/user_model.dart';
import '../testing/messages.dart';

class SpecialMessagesPage extends StatelessWidget {
  final List<DocumentSnapshot> specialMessages;
  final String userId;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  SpecialMessagesPage({Key? key, required this.specialMessages, required this.userId})
      : super(key: key);

  DateTime? _lastDisplayedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Special Messages'),
      ),
      body: ListView.builder(
        itemCount: specialMessages.length,
        itemBuilder: (context, index) {
          final DocumentSnapshot document = specialMessages[index];
          return _buildSpecialMessageItem(document, index);
        },
      ),
    );
  }

  Widget _buildSpecialMessageItem(DocumentSnapshot document, int index) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid) ? Alignment.centerRight : Alignment.centerLeft;
    String senderDisplayName = (alignment == Alignment.centerRight) ? 'You' : (data['senderUsername'] ?? data['senderEmail']);
    bool isSpecial = true;

    Timestamp timestamp = data['timestamp'] as Timestamp;
    DateTime messageDate = timestamp.toDate();

    bool isNewDate = _lastDisplayedDate == null ||
        messageDate.day != _lastDisplayedDate!.day ||
        messageDate.month != _lastDisplayedDate!.month ||
        messageDate.year != _lastDisplayedDate!.year;

    if (isNewDate) {
      _lastDisplayedDate = messageDate;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isNewDate)
          Container(
            height: 1,
            color: Colors.black,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
          ),
        if (isNewDate)
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              _formatDate(messageDate),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Container(
          alignment: alignment,
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: (alignment == Alignment.centerLeft) ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              if (alignment == Alignment.centerLeft)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, top: 20.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ),
              Column(
                crossAxisAlignment: (alignment == Alignment.centerLeft) ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                children: [
                  Text(senderDisplayName),
                  const SizedBox(height: 5),
                  ChatBubble(message: data['message'], isSpecial: isSpecial),
                ],
              ),
              if (alignment == Alignment.centerRight)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 20.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
        if (index == specialMessages.length - 1)
          Container(
            height: 1,
            color: Colors.black,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
          ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
