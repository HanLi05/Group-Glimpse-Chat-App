import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  // number of groups and DMs
  final int numGroups;
  final int numDMs;

  const ProfilePage({Key? key, required this.numGroups, required this.numDMs}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // instances of firebase auth and firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _username = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // get the username and email for the current user
    User? user = _auth.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

      setState(() {
        _username = userDoc['username'];
        _email = user.email ?? '';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // display username
            const Text(
              'Username:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(
              _username,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            // display email
            const Text(
              'Email:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(
              _email,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            // display number of groups
            const Text(
              'Number of Groups:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.numGroups.toString(),
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            // display number of DMs
            const Text(
              'Number of DMs:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.numDMs.toString(),
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
