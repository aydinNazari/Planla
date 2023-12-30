class User {
  final String uid;
  final String name;
  final String email;
  final String imageurl;
  final int score;


  User({
    required this.uid,
    required this.email,
    required this.name,
    required this.imageurl,
    required this.score
  });


  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'imageurl': imageurl,
      'score': score,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        uid: map['uid'] ?? '',
        email: map['email'] ?? '',
        name: map['name'] ?? '',
        imageurl: map['imageurl'] ?? '',
      score: map['score'] ?? '',

    );
  }
}
