import 'package:bro/screens/homePage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bro/services/chat/chat_service.dart';

class SendMessagePage extends StatefulWidget {
  @override
  _SendMessagePageState createState() => _SendMessagePageState();
}

class _SendMessagePageState extends State<SendMessagePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();
  List<String> selectedGroups = [];
  List<bool> checkedStates = [];
  final ChatService _chatService = ChatService();

  @override
  void initState() {
    super.initState();
    fetchUserGroups();
  }


  void fetchUserGroups() async {
    // Fetch all group chats that include the current user's UID
    QuerySnapshot chatRoomsSnapshot = await _fireStore
        .collection('chat_rooms')
        .where('participants', arrayContains: _auth.currentUser!.uid)
        .get();

    List<String> groups = [];
    List<bool> states = [];

    for (QueryDocumentSnapshot doc in chatRoomsSnapshot.docs) {
      List<dynamic> users = doc['participants'];
      // Exclude the current user from the list
      users.remove(_auth.currentUser!.uid);

      List<String> displayNames = await fetchDisplayNames(users.cast<String>());

      // Join the remaining display names with commas
      String group = displayNames.join(', ');
      groups.add(group);
      states.add(true); // Initialize all groups as checked initially
    }

    setState(() {
      selectedGroups = groups;
      checkedStates = states;
    });
  }

  Future<List<String>> fetchDisplayNames(List<String> uids) async {
    List<String> displayNames = [];

    for (String uid in uids) {
      DocumentSnapshot userSnapshot =
      await _fireStore.collection('users').doc(uid).get();

      if (userSnapshot.exists) {
        String displayName = userSnapshot['username'];
        displayNames.add(displayName);
      }
    }

    return displayNames;
  }

  // void _sendMessage() async {
  //   String message = _messageController.text.trim();
  //
  //   if (message.isNotEmpty) {
  //     for (int i = 0; i < selectedGroups.length; i++) {
  //       if (checkedStates[i]) {
  //         // Get the roomId based on the groupName
  //         QuerySnapshot chatRoomSnapshot = await _fireStore
  //             .collection('chat_rooms')
  //             .where('participants', arrayContains: _auth.currentUser!.uid)
  //             .get();
  //
  //         if (chatRoomSnapshot.docs.isNotEmpty) {
  //           String roomId = chatRoomSnapshot.docs[i].id;
  //
  //           // Send the message to each selected group chat
  //           await _fireStore.collection('chat_rooms').doc(roomId).collection('messages').add({
  //             'text': message,
  //             'senderId': _auth.currentUser!.uid,
  //             'timestamp': FieldValue.serverTimestamp(),
  //             'special': true,
  //           });
  //
  //           // Update the last message and last updated time in the chat_rooms collection
  //           await _fireStore.collection('chat_rooms').doc(roomId).update({
  //             'lastMessage': message,
  //             'lastUpdated': FieldValue.serverTimestamp(),
  //           });
  //         }
  //       }
  //     }
  //
  //     // Clear the text field after sending the message
  //     _messageController.clear();
  //
  //     Navigator.pop(context);
  //   }
  // }

  void _sendMessage() async {
    String message = _messageController.text.trim();

    if (message.isNotEmpty) {
      for (int i = 0; i < selectedGroups.length; i++) {
        if (checkedStates[i]) {
          List<String> receiverIds = [];
          List<String> displayNames = selectedGroups[i].split(', ');

          for (String displayName in displayNames) {
            String userId = await _chatService.fetchUserIdByDisplayName(displayName);
            receiverIds.add(userId);
          }

          await _chatService.sendMessage(receiverIds, message, true);
        }
      }

      // Clear the text field after sending the message
      _messageController.clear();

      Navigator.pop(context);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          },
        ),
        title: Text('Group Glimpse Message'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _messageController,
              decoration: InputDecoration(labelText: 'Enter your message'),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: selectedGroups.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(selectedGroups[index]),
                    value: checkedStates[index],
                    onChanged: (bool? value) {
                      setState(() {
                        checkedStates[index] = value ?? false;
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _sendMessage,
              child: Text('Send Message'),
            ),
          ],
        ),
      ),
    );
  }
}
