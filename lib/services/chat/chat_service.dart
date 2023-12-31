import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bro/models/message.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // sending messages
  Future<void> sendMessage(List<String> receiverId, String message, bool special) async {
    // get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final String currentUsername = await _fetchUsername(_firebaseAuth.currentUser!.uid);
    final Timestamp timestamp = Timestamp.now();
    List<String> participantsEmails = await _fetchParticipantsEmails(receiverId, currentUserEmail);
    List<String> participantsUsernames = await _fetchParticipantsUsernames(receiverId, currentUsername);

    // create new message
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      senderUsername: currentUsername,
      receiverId: receiverId,
      timestamp: timestamp,
      message: message,
      special: special,
    );

    // construct chat room id from current user id and receiver id
    List<String> ids = [currentUserId];
    ids.addAll(receiverId);
    ids.sort();
    String chatRoomId = ids.join("_");

    // set fields of chat_room
    await _fireStore.collection('chat_rooms').doc(chatRoomId).set({
      'participants': ids,
      'emails': participantsEmails,
      'users': participantsUsernames,
      'lastUpdated': timestamp,
      'lastMessage': message,
    }, SetOptions(merge: true));

    // add messages to database
    await _fireStore.collection('chat_rooms').doc(chatRoomId).collection('messages').add(newMessage.toMap());
  }

  // get the special messages of a given group
  Stream<QuerySnapshot> getSpecialMessages(String userId) {
    // create chat room using userIds of members
    List<String> ids = [userId];
    String chatRoomId = ids.join("_");

    // return the collection of messages, filtered by special and ordered by timestamp
    return _fireStore.collection('chat_rooms').doc(chatRoomId).collection('messages').where('special', isEqualTo: true).orderBy('timestamp', descending: false).snapshots();
  }

  // delete the collection and chat_room
  Future<void> deleteChatCollection(BuildContext context, List<String> userIds) async {
    // build chat room id
    userIds.add(_firebaseAuth.currentUser!.uid);
    userIds.sort();

    // display confirmation
    bool confirmDelete = await _showDeleteConfirmationDialog(context);

    // delete if confirm
    if (confirmDelete) {
      try {
        String chatRoomId = userIds.join("_");

        // Get a reference to the main chat room document
        DocumentReference mainChatRoomRef =
        _fireStore.collection('chat_rooms').doc(chatRoomId);

        // Create a batch
        WriteBatch batch = _fireStore.batch();

        // Delete documents in the subcollection
        QuerySnapshot subCollectionSnapshot =
        await mainChatRoomRef.collection('messages').get();
        subCollectionSnapshot.docs.forEach((doc) {
          batch.delete(doc.reference);
        });

        // Delete the main chat room document
        batch.delete(mainChatRoomRef);

        // Commit the batch
        await batch.commit();
      } catch (e) {
        print('error deleting chat collection: $e');
        // Handle error as needed
      }
    }
  }

  // delete confirmation dialog
  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Warning: Deleting the chat will delete it for everyone. Do you want to proceed?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirmed delete
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User canceled delete
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  // getting messages
  Stream<QuerySnapshot> getMessages(List<String> userId, String otherUserId) {
    // construct chat_room id
    List<String> ids = [otherUserId];
    ids.addAll(userId);
    ids.sort();
    String chatRoomId = ids.join("_");

    return _fireStore.collection('chat_rooms').doc(chatRoomId).collection('messages').orderBy('timestamp', descending: false).snapshots();
  }

  // helper function to get emails of everyone in a chat_room
  Future<List<String>> _fetchParticipantsEmails(List<String> participantUIDs, String currentEmail) async {
    List<String> participantsEmails = [currentEmail];

    for (String uid in participantUIDs) {
      DocumentSnapshot userSnapshot = await _fireStore.collection('users').doc(uid).get();

      if (userSnapshot.exists) {
        participantsEmails.add(userSnapshot['email']);
      }
    }

    return participantsEmails;
  }

  // get the usernames given their ids
  Future<List<String>> _fetchParticipantsUsernames(List<String> participantUIDs, String currentUsername) async {
    // add the current user's username to have all usernames within group
    List<String> participantsUsernames = [currentUsername];

    for (String uid in participantUIDs) {
      DocumentSnapshot userSnapshot = await _fireStore.collection('users').doc(uid).get();

      if (userSnapshot.exists) {
        participantsUsernames.add(userSnapshot['username']);
      }
    }

    return participantsUsernames;
  }

  // get the username given userId from 'users' collection
  Future<String> _fetchUsername(String userId) async {
    DocumentSnapshot userSnapshot = await _fireStore.collection('users').doc(userId).get();
    return userSnapshot.exists ? userSnapshot['username'] : '';
  }

  // get the id given username
  Future<String> fetchUserIdByDisplayName(String displayName) async {
    try {
      QuerySnapshot userSnapshot = await _fireStore.collection('users').where('username', isEqualTo: displayName).get();

      if (userSnapshot.docs.isNotEmpty) {
        return userSnapshot.docs[0].id;
      } else {
        return '';
      }
    } catch (error) {
      print('error getting uid from username: $error');
      return '';
    }
  }


}

