import 'package:bro/components/text_field.dart';
import 'package:bro/services/chat/chat_bubble.dart';
import 'package:bro/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../testing/user_model.dart';
import '../testing/messages.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final List<String> receiverUserID;
  ChatPage({super.key, required this.receiverUserEmail, required this.receiverUserID});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatPage> {

  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverUserID, _messageController.text);
    _messageController.clear();
    }
  }

  Widget _buildMessageList() {
    return StreamBuilder(stream: _chatService.getMessages(
      widget.receiverUserID, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error' + snapshot.error.toString());
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

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid) ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Column(
        children: [
          Text(data['senderEmail']),
          const SizedBox(height: 5),
          ChatBubble(message: data['message'])
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Expanded(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(text: widget.receiverUserEmail, style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
              ),),
            ],
          ),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      // body: Column(
      //   children: <Widget>[
      //     Expanded(
      //       child: ListView.builder(
      //           reverse: true,
      //           padding: EdgeInsets.all(20),
      //           itemCount: messages.length,
      //           itemBuilder: (BuildContext context, int index) {
      //             final Message message = messages[index];
      //             final bool isCurrent = message.sender.id == currentUser.id;
      //             return _ChatBubble(message, isCurrent);
      //           }
      //       ),
      //     ),
      //   ],
      // ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),
          const SizedBox(height: 25),
        ]
      )
    );

  }
}