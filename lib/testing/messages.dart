import './user_model.dart';

class Message {
  final User sender;
  final String time; // Would usually be type DateTime or Firebase Timestamp in production apps
  final String text;

  Message({
    required this.sender,
    required this.time,
    required this.text,
  });
}

// EXAMPLE CHATS ON HOME SCREEN
List<Message> chats = [
  Message(
    sender: p1,
    time: '5:40 PM',
    text: 'testing123',
  ),
  Message(
    sender: p2,
    time: '4:30 PM',
    text: 'testing123',
  ),
  Message(
    sender: p3,
    time: '3:30 PM',
    text: 'testing123',
  ),
  Message(
    sender: p4,
    time: '2:30 PM',
    text: 'testing123',
  ),
  Message(
    sender: p5,
    time: '1:30 PM',
    text: 'testing123',
  ),
  Message(
    sender: p6,
    time: 'testing123',
    text: 'hheheheeheh',
  ),
  Message(
    sender: p7,
    time: '11:30 AM',
    text: 'testing123',
  ),
  Message(
    sender: p8,
    time: '12:45 AM',
    text: 'Ytesting123',
  ),
];

// EXAMPLE MESSAGES IN CHAT SCREEN
List<Message> messages = [
  Message(
    sender: p1,
    time: '5:30 PM',
    text: 'yoyoyoyooy',
  ),
  Message(
    sender: currentUser,
    time: '4:30 PM',
    text: 'asdfasdfa.',
  ),
  Message(
    sender: p1,
    time: '3:45 PM',
    text: 'asdfffefeweaefw',
  ),
  Message(
    sender: p1,
    time: '3:15 PM',
    text: 'afsffeefwweewwe',
  ),
  Message(
    sender: currentUser,
    time: '2:30 PM',
    text: 'asdffffdfsafdafd',
  ),
  Message(
    sender: currentUser,
    time: '2:30 PM',
    text: 'ffffffffffffffffffffffffffffffffff',
  ),
  Message(
    sender: currentUser,
    time: '2:30 PM',
    text: 'yes',
  ),
  Message(
    sender: p1,
    time: '2:00 PM',
    text: 'asd',
  ),
];