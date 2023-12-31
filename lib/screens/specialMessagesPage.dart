import 'package:bro/services/chat/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// special messages page includes all the special messages separated by date
class SpecialMessagesPage extends StatelessWidget {
  // list of special messages
  final List<DocumentSnapshot> specialMessages;
  // user id
  final String userId;
  // instance of firebase auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  SpecialMessagesPage({Key? key, required this.specialMessages, required this.userId})
      : super(key: key);

  // store the last displayed date so that when it's different than current, start a new header
  DateTime? _lastDisplayedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Special Messages'),
      ),
      // build a list of all the special messages
      body: ListView.builder(
        itemCount: specialMessages.length,
        itemBuilder: (context, index) {
          final DocumentSnapshot document = specialMessages[index];
          return _buildSpecialMessageItem(document, index);
        },
      ),
    );
  }

  // widget for each special message
  Widget _buildSpecialMessageItem(DocumentSnapshot document, int index) {
    // extract data from document
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    // determine alignment based on whether sender is current user (right if current, left if not)
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid) ? Alignment.centerRight : Alignment.centerLeft;
    // change display name to 'you' if right aligned
    String senderDisplayName = (alignment == Alignment.centerRight) ? 'You' : (data['senderUsername'] ?? data['senderEmail']);
    bool isSpecial = true;

    // convert timestamp to DateTime
    Timestamp timestamp = data['timestamp'] as Timestamp;
    DateTime messageDate = timestamp.toDate();

    // check if it's a new date
    bool isNewDate = _lastDisplayedDate == null || messageDate.day != _lastDisplayedDate!.day || messageDate.month != _lastDisplayedDate!.month || messageDate.year != _lastDisplayedDate!.year;

    if (isNewDate) {
      _lastDisplayedDate = messageDate;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // show the line separator if it's a new date
        if (isNewDate)
          Container(
            height: 1,
            color: Colors.black,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
          ),
        // show the date if it's a new date
        if (isNewDate)
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              _formatDate(messageDate),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Container(
          alignment: alignment,
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: (alignment == Alignment.centerLeft) ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              // create avatar when right aligned
              if (alignment == Alignment.centerLeft)
                const Padding(
                  padding: EdgeInsets.only(right: 8.0, top: 20.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ),
              // create chat bubble depending on alignment
              Column(
                crossAxisAlignment: (alignment == Alignment.centerLeft) ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                children: [
                  Text(senderDisplayName),
                  const SizedBox(height: 5),
                  ChatBubble(message: data['message'], isSpecial: isSpecial),
                ],
              ),
              // create avatar when right aligned
              if (alignment == Alignment.centerRight)
                const Padding(
                  padding: EdgeInsets.only(left: 8.0, top: 20.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
        // line separator at bottom
        if (index == specialMessages.length - 1)
          Container(
            height: 1,
            color: Colors.black,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
          ),
      ],
    );
  }

  // turn DateTime into formatted string
  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
