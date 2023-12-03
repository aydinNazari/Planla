import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:planla/models/today_model.dart';
import 'package:planla/utiles/constr.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart' as model;
import '../providersClass/provider_user.dart';

class FirestoreMethods {

  Future<bool> firestoreUpload(
      BuildContext context, model.User user, TodayModel todayModel) async {
    bool res = false;
    try {
      //Timestamp timestamp = Timestamp.fromMillisecondsSinceEpoch(1641063600000);

      // tarihi yanlış çeviriyor onu düzelt
      

      // DateTime'i Timestamp'e çevir
      
      
     DateTime dateTime =DateTime.now();
     String datetimeToCollect=getDatePart(dateTime.toString());
     //Timestamp timestamp = Timestamp.fromDate(dateTime);
      //DateTime dateTime = timestamp.toDate().toUtc();
      //String timePart = getTimePart((dateTime).toString());
      var allDoc = await firestore
          .collection('todaytext')
          .doc(user.uid)
          .collection('dates')
          .get();
      int count = allDoc.docs.length;
      await firestore
          .collection('todaytext')
          .doc(user.uid)
          .collection('dates')
          .doc('$datetimeToCollect-$count')
          .set(todayModel.toMap());
      res = true;

    } on FirebaseException catch (e) {
      showSnackBar(context, e.toString(), Colors.red);
      print(e.toString());
    }

    return res;
  }

  String getDatePart(String fullDateTimeString) {
    // " " karakterinden önceki kısmı al
    int spaceIndex = fullDateTimeString.indexOf(" ");
    String datePart = fullDateTimeString.substring(0, spaceIndex);

    return datePart;
  }

  Future<bool> getFiresoreData(BuildContext context) async {
    bool res = false;
    List<TodayModel> tempList=[];
    final user=Provider.of<ProviderUser>(context,listen: false).user;
    try {
      var snap = await firestore
          .collection('todaytext')
          .doc(user.uid)
          .collection('dates')
          .get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
          in snap.docs) {

        Map<String, dynamic> data = documentSnapshot.data();
        Timestamp dateTime = data['dateTime'];
        bool done = data['done'];
        bool important = data['important'];
        String text = data['text'];
        String typeWork = data['typeWork'];

        TodayModel todayModel = TodayModel(
            text: text,
            dateTime: dateTime,
            done: done,
            important: important,
            typeWork: typeWork);

       /* String documentId = documentSnapshot.id;
        print('aaaaaaaaaaaaaaaaaaaaaaaaaaa');
        print("Document ID: $documentId");
        print("Document Data: $data");
        print(todayModel.dateTime);
        print(todayModel.text);
        print(todayModel.done);
        print(todayModel.important);
        print(todayModel.typeWork);*/
         tempList.add(todayModel);
      }
      Provider.of<ProviderUser>(context,listen: false).setTodayList(tempList);
      res=true;
    } on FirebaseException catch (e) {
      showSnackBar(context, e.toString(), Colors.red);
    }
    return res;
  }
}
