class User {
  final String uid;
  final String name;
  final String email;
  final String imageurl;


  User({
    required this.uid,
    required this.email,
    required this.name,
    required this.imageurl,
  });


  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'imageurl': imageurl,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        uid: map['uid'] ?? '',
        email: map['email'] ?? '',
        name: map['name'] ?? '',
        imageurl: map['imageurl'] ?? '',

    );
  }
}
