import 'package:bro/testing/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bro/models/message.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // sending messages
  Future<void> sendMessage(List<String> receiverId, String message) async {
    // get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();
    List<String> participantsEmails = await _fetchParticipantsEmails(receiverId, currentUserEmail);

    // create new message
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      timestamp: timestamp,
      message: message,
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
      'lastUpdated': timestamp,
    }, SetOptions(merge: true));

    // add messages to database
    await _fireStore.collection('chat_rooms').doc(chatRoomId).collection('messages').add(newMessage.toMap());
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

}

