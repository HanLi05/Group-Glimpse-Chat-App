import 'package:bro/screens/homePage.dart';
import 'package:bro/services/auth/auth_gate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './chatPage.dart';
import 'package:provider/provider.dart';
import 'package:bro/services/auth/auth_service.dart';

// page for creating a new group by selecting users from list and pressing button
class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  // firebase authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // list of the emails for the users selected to be in the new group
  List<String> selectedEmails = [];
  // list of the ids for the users selected to be in the new group
  List<String> selectedUIDs = [];
  // list of usernames for the users selected to be in the new group
  List<String> selectedUsernames = [];

  // sign out, send to login page thru auth gate
  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const AuthGate(),
      ),
    );
  }

  // build page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // create bar at top of page
      appBar: AppBar(
        elevation: 8,
        // create leading chat button to redirect to home page
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
        // create action button for logout
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: signOut,
          ),
        ],
      ),
      body: Column(
        children: [
          // list of all users with checkbox functionality
          _buildUserList(),
          // create group button
          _buildCreateGroupButton(context),
        ],
      )
    );
  }

  // widget for list of users
  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      // get instance of items within 'users' firebase collection
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
            // build list of user item widgets excluding null
            children: documents.where((doc) => doc.data() != null).map<Widget>((doc) => _buildUserListItem(doc)).toList(),
          ),
        );
      },
    );
  }

  // build individual widget for each user selection option
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    // return list tile widget if data value is not null and not current user
    // these list tiles represent other users that the current user may want to add
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
                selectedUsernames.add(data['username']);
              }
              else {
                selectedEmails.remove(data['email']);
                selectedUIDs.remove(data['uid']);
                selectedUsernames.add(data['username']);
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
              receiverUsernames: selectedUsernames.join(', '),
            ),
          ),
        );
      },
      child: Text('Create Group Chat'),
    );
  }
}