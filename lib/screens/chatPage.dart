import 'package:bro/components/text_field.dart';
import 'package:bro/screens/homePage.dart';
import 'package:bro/screens/specialMessagesPage.dart';
import 'package:bro/services/chat/chat_bubble.dart';
import 'package:bro/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// chat page that displays messages and allows users to send messages to a specific group
class ChatPage extends StatefulWidget {
  // properties of chat recipient
  final String receiverUserEmail;
  final String receiverUsernames;
  final List<String> receiverUserID;
  const ChatPage({super.key, required this.receiverUsernames, required this.receiverUserEmail, required this.receiverUserID});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatPage> {
  // text controller for user inputs
  final TextEditingController _messageController = TextEditingController();
  // custom service for handling chat-related functionality
  final ChatService _chatService = ChatService();
  // firebase authentication instance
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // list to store special messages to be passed to specialMessagesPage
  List<DocumentSnapshot> specialMessages = [];

  // function to send message
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      // call chatService send message function
      await _chatService.sendMessage(widget.receiverUserID, _messageController.text, false);
    _messageController.clear();
    }
  }

  // function to delete entire group
  void _deleteCollection() async {
    // call chatService delete chat function
    await _chatService.deleteChatCollection(context, widget.receiverUserID);
    // send user to home page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }

  // widget to build the list of message widgets
  Widget _buildMessageList() {
    specialMessages = [];
    return StreamBuilder(
      // call chatService get message function
      stream: _chatService.getMessages(widget.receiverUserID, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        return ListView(
          children: snapshot.data!.docs.map((document) => _buildMessageItem(document)).toList(),
        );
      },
    );
  }

  // widget for individual message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    // message alignment based on if sender is the current user (true = right align)
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid) ? Alignment.centerRight : Alignment.centerLeft;
    // display name based on if sender is current user (true = use 'You')
    String senderDisplayName = (alignment == Alignment.centerRight) ? 'You' : (data['senderUsername'] ?? data['senderEmail']);

    bool isSpecial = false;
    if (data.containsKey('special') && data['special'] is bool) {
      isSpecial = data['special'];
    }

    if (isSpecial) {
      specialMessages.add(document);
    }

    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: (alignment == Alignment.centerLeft) ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          // create avatar to the left if appropriate
          if (alignment == Alignment.centerLeft)
            const Padding(
              padding: EdgeInsets.only(right: 8.0, top: 20.0),
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white),
              ),
            ),
          // create username and chatBubble with appropriate alignment
          Column(
            crossAxisAlignment: (alignment == Alignment.centerLeft) ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              Text(senderDisplayName),
              const SizedBox(height: 5),
              ChatBubble(message: data['message'], isSpecial: isSpecial),
            ],
          ),
          // create avatar to the right if appropriate
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
    );
  }

  // widget for message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Expanded(
            // custom text field
            child: MyTextField(
              controller: _messageController,
              hintText: 'Enter message',
              obscureText: false,
            ),
          ),
          IconButton(onPressed: sendMessage, icon: const Icon(Icons.arrow_upward, size: 40,))
        ]
      ),
    );
  }

  // widget for special messages button
  Widget _buildSpecialMessagesButton(BuildContext context) {
    return ElevatedButton(
      // send to specialMessagesPage when pressed
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpecialMessagesPage(
              specialMessages: specialMessages,
              userId: widget.receiverUserID[0],
            ),
          ),
        );
      },
      child: const Text('Special Messages'),
    );
  }

  // build page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // build bar on top of page
      appBar: AppBar(
        centerTitle: true,
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(text: widget.receiverUsernames,
                style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        // back button that goes back to previous page
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            }),
        // action button for deleting the chat
        actions: [
          IconButton(
            onPressed: _deleteCollection,
            icon: const Icon(Icons.delete),
          ),
        ],
      ),

      // build rest of page
      body: Column(
        children: [
          Expanded(
            // messages
            child: _buildMessageList(),
          ),
          // message input area
          _buildMessageInput(),
          const SizedBox(height: 25),
          // special messages button
          _buildSpecialMessagesButton(context),
        ],
      ),
    );
  }
}