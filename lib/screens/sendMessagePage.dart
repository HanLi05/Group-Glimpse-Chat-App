import 'package:bro/screens/homePage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bro/services/chat/chat_service.dart';

class SendMessagePage extends StatefulWidget {
  @override
  _SendMessagePageState createState() => _SendMessagePageState();
}

class _SendMessagePageState extends State<SendMessagePage> {
  // instances of firebase auth and firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  // text editing controller for typing special message
  final TextEditingController _messageController = TextEditingController();
  // list of groups that user has selected to send messages to
  List<String> selectedGroups = [];
  // list of bools describing which groups are checked
  List<bool> checkedStates = [];
  // chat service
  final ChatService _chatService = ChatService();

  @override
  void initState() {
    super.initState();
    fetchUserGroups();
  }

  // function to fetch group chats that include current user id
  void fetchUserGroups() async {
    QuerySnapshot chatRoomsSnapshot = await _fireStore.collection('chat_rooms').where('participants', arrayContains: _auth.currentUser!.uid).get();

    List<String> groups = [];
    List<bool> states = [];

    // iterate thru each chat room (already filtered)
    for (QueryDocumentSnapshot doc in chatRoomsSnapshot.docs) {
      // remove current user
      List<dynamic> users = doc['participants'];
      users.remove(_auth.currentUser!.uid);

      // create list for the display names of participants in a chat room
      List<String> displayNames = await fetchDisplayNames(users.cast<String>());

      // join the list items using comma
      String group = displayNames.join(', ');
      groups.add(group);
      // initial checkboxes are checked
      states.add(true);
    }

    setState(() {
      selectedGroups = groups;
      checkedStates = states;
    });
  }

  // function to return list of usernames based on a list of user ids
  Future<List<String>> fetchDisplayNames(List<String> uids) async {
    List<String> displayNames = [];

    // iterate thru ids and get corresponding username value from users collection
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

  // function to send message using chat service
  void _sendMessage() async {
    String message = _messageController.text.trim();
    // loop thru the selected groups
    if (message.isNotEmpty) {
      for (int i = 0; i < selectedGroups.length; i++) {
        if (checkedStates[i]) {
          // transform the display names of the groups into ids
          List<String> receiverIds = [];
          List<String> displayNames = selectedGroups[i].split(', ');

          for (String displayName in displayNames) {
            String userId = await _chatService.fetchUserIdByDisplayName(displayName);
            receiverIds.add(userId);
          }

          await _chatService.sendMessage(receiverIds, message, true);
        }
      }

      // clear field and return to previous page
      _messageController.clear();

      Navigator.pop(context);
    }
  }

  // build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading back arrow button, direct to previous page
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          },
        ),
        title: const Text('Group Glimpse Message'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // message controller for message input
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(labelText: 'Enter your message'),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              // list of groups with checked box logic
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
            // send message button
            ElevatedButton(
              onPressed: _sendMessage,
              child: const Text('Send Message'),
            ),
          ],
        ),
      ),
    );
  }
}
