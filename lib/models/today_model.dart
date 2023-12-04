import 'package:cloud_firestore/cloud_firestore.dart';

class TodayModel {
  String text;
  Timestamp dateTime;
  bool done;
  bool important;
  String typeWork;
  String email;
  String uid;

  TodayModel(
      {required this.text,
      required this.dateTime,
      required this.done,
      required this.important,
        required this.typeWork,
      required this.email,
        required this.uid
      });
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'dateTime':dateTime,
      'done' : done,
      'important' : important,
      'typeWork' : typeWork,
      'email' : email,
      'uid' : uid
    };
  }

  factory TodayModel.fromMap(Map<String, dynamic> map) {
    return TodayModel(
        text: map['text'] ?? '',
        dateTime: map['dateTime'] ?? '',
        done: map['done'] ?? '',
        important: map['important'] ?? '',
        typeWork: map['typeWork'] ?? '',
        email: map['email'] ?? '',
        uid: map['uid'] ?? '');
  }
}
