import 'package:bro/screens/homePage.dart';
import 'package:bro/screens/loginPage.dart';
import 'package:bro/services/auth/auth_gate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../testing/messages.dart';
import './chatPage.dart';
import 'package:provider/provider.dart';
import 'package:bro/services/auth/auth_service.dart';

class CreateGroupPage extends StatefulWidget {
  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<String> selectedEmails = [];
  List<String> selectedUIDs = [];

  // sign out, send to login page thru auth gate
  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AuthGate(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 8,
        leading: IconButton(
          icon: Icon(Icons.chat),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                ),
              ),
            );
          },
        ),
        title: Text('Create Group'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.white,
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: signOut,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildUserList(),
          _buildCreateGroupButton(context),
        ],
      )
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('error');
        }

        if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) {
          return const Text('loading..');
        }

        List<DocumentSnapshot> documents = snapshot.data!.docs;

        return Expanded(
          child: ListView(
            children: documents.where((doc) => doc.data() != null).map<Widget>((doc) => _buildUserListItem(doc)).toList(),
          ),
        );
      },
    );
  }

  // build list of widgets that have text for all emails other than self
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    if (data != null && _auth.currentUser!.email != data['email']) {
      bool isChecked = selectedEmails.contains(data['email']);
      return ListTile(
        title: Text(data['email']),
        tileColor: isChecked ? Colors.blue.withOpacity(0.1) : null,
        // checkbox that adds/removes selection from list
        leading: Checkbox(
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              if (value != null && value) {
                selectedEmails.add(data['email']);
                selectedUIDs.add(data['uid']);
              }
              else {
                selectedEmails.remove(data['email']);
                selectedUIDs.remove(data['uid']);
              }
            });
          },
        ),
        onTap: () {},
      );
    }
    else {
      return Container();
    }
  }

  // button to create ChatPage using lists
  Widget _buildCreateGroupButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              receiverUserEmail: selectedEmails.join(', '),
              receiverUserID: selectedUIDs,
            ),
          ),
        );
      },
      child: Text('Create Group Chat'),
    );
  }
}