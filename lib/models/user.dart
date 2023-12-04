class User {
  final String uid;
  final String name;
  final String email;
  final String imageurl;
  late int doneCount;
  late int taskCount;

  User({
    required this.uid,
    required this.email,
    required this.name,
    required this.imageurl,
    required this.doneCount,
    required this.taskCount,
  });


  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'imageurl': imageurl,
      'doneCount': doneCount,
      'taskCount': taskCount,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        uid: map['uid'] ?? '',
        email: map['email'] ?? '',
        name: map['name'] ?? '',
        imageurl: map['imageurl'] ?? '',
      doneCount: map['doneCount'] ?? '',
      taskCount: map['taskCount'] ?? '',

    );
  }
}
