class User {
  final int id;
  final String name;
  final String imageUrl;
  final bool isOnline;

  User({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.isOnline,
  });
}

// YOU - current user
final User currentUser = User(
  id: 0,
  name: 'mee',
  imageUrl: 'assets/images/smiley.png',
  isOnline: true,
);

// USERS
final User p1 = User(
  id: 1,
  name: 'P1',
  imageUrl: 'assets/images/smiley.png',
  isOnline: true,
);
final User p2 = User(
  id: 2,
  name: 'P2',
  imageUrl: 'assets/images/smiley.png',
  isOnline: true,
);
final User p3 = User(
  id: 3,
  name: 'P3',
  imageUrl: 'assets/images/smiley.png',
  isOnline: false,
);
final User p4 = User(
  id: 4,
  name: 'P4',
  imageUrl: 'assets/images/smiley.png',
  isOnline: false,
);
final User p5 = User(
  id: 5,
  name: 'P5',
  imageUrl: 'assets/images/smiley.png',
  isOnline: true,
);
final User p6 = User(
  id: 6,
  name: 'P6',
  imageUrl: 'assets/images/smiley.png',
  isOnline: false,
);
final User p7 = User(
  id: 7,
  name: 'P7',
  imageUrl: 'assets/images/smiley.png',
  isOnline: false,
);
final User p8 = User(
  id: 8,
  name: 'P8',
  imageUrl: 'assets/images/smiley.png',
  isOnline: false,
);