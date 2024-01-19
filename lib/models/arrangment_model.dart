class Arrangment {
  final String imgUrl;
  final String name;
  final String uid;
  final String email;
  final double score;

  Arrangment(
      {required this.imgUrl,
      required this.uid,
      required this.email,
      required this.name,
      required this.score});

  Map<String, dynamic> toMap() {
    return {
      'imgUrl': imgUrl,
      'name': name,
      'uid': uid,
      'score': score,
      'email': email,
    };
  }

  factory Arrangment.fromMap(Map<String, dynamic> map) {
    return Arrangment(
      imgUrl: map['imgUrl'] ?? '',
      name: map['name'] ?? '',
      uid: map['uid'] ?? '',
      score: map['score'] ?? 0.0,
      email: map['email'] ?? '',
    );
  }

}
