import 'package:cloud_firestore/cloud_firestore.dart';

class TodayModel {
  String text;
  Timestamp dateTime;
  bool done;
  bool important;
  String typeWork;

  TodayModel(
      {required this.text,
      required this.dateTime,
      required this.done,
      required this.important,
        required this.typeWork});
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'dateTime':dateTime,
      'done' : done,
      'important' : important,
      'typeWork' : typeWork
    };
  }

  factory TodayModel.fromMap(Map<String, dynamic> map) {
    return TodayModel(
        text: map['text'] ?? '',
        dateTime: map['dateTime'] ?? '',
        done: map['done'] ?? '',
        important: map['important'] ?? '',
        typeWork: map['typeWork'] ?? '');
  }
}
