class User {
  final String uid;
  final String username;
  final String email;
  final String imageurl;

  User(
      {required this.uid,
      required this.email,
      required this.username,
      required this.imageurl});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'imageurl': imageurl
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        uid: map['uid'] ?? '',
        email: map['email'] ?? '',
        username: map['username'] ?? '',
        imageurl: map['imageurl'] ?? '');
  }
}
