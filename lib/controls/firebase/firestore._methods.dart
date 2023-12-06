import 'package:cloud_firestore/cloud_firestore.dart';
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
      String datetimeToCollect = getDatePart();
      var allDoc = await firestore
          .collection('todaytext')
          .doc(user.uid)
          .collection(datetimeToCollect)
          .get();
      int count = allDoc.docs.length;
      await firestore
          .collection('todaytext')
          .doc(user.uid)
          .collection(datetimeToCollect)
          .doc(count.toString())
          .set(todayModel.toMap());
      res = true;
    } on FirebaseException catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
    }

    return res;
  }

  String getDatePart() {
    // " " karakterinden önceki kısmı al
    DateTime dateTime = DateTime.now();
    int spaceIndex = (dateTime.toString()).indexOf(" ");
    String datePart = (dateTime.toString()).substring(0, spaceIndex);

    return datePart;
  }

  Future<bool> getFiresoreData(BuildContext context) async {
    bool res = false;
    List<TodayModel> tempList = [];
    final user = Provider.of<ProviderUser>(context, listen: false).user;
    //DateTime dateTime = DateTime.now();
    String datetimeToCollect = getDatePart();
    try {
      var snap = await firestore
          .collection('todaytext')
          .doc(user.uid)
          .collection(datetimeToCollect)
          .get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
          in snap.docs) {
        Map<String, dynamic> data = documentSnapshot.data();
        Timestamp dateTime =
            data['dateTime'] ?? Timestamp.fromMillisecondsSinceEpoch(0);
        bool done = data['done'] ?? false;
        bool important = data['important'] ?? false;
        String text = data['text'] ?? '';
        String typeWork = data['typeWork'] ?? '';

        TodayModel todayModel = TodayModel(
            text: text,
            dateTime: dateTime,
            done: done,
            important: important,
            typeWork: typeWork,
            email: user.email,
            uid: user.uid);

        tempList.add(todayModel);
      }
      if (context.mounted) {
        Provider.of<ProviderUser>(context, listen: false)
            .setTodayList(tempList);
      }
      res = true;
    } on FirebaseException catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
    }
    return res;
  }

  Future<bool> updateUser(BuildContext context, bool taskProcess,
      bool doneProcess, bool statueValue) async {
    bool res = false;
    try {
      final user = Provider.of<ProviderUser>(context, listen: false);
      if (taskProcess) {
        int taskCount = user.user.taskCount;
        taskCount++;
        await firestore
            .collection('users')
            .doc(user.user.uid)
            .update({'taskCount': taskCount});
        model.User temp = user.user;
        temp.taskCount = taskCount;
        user.setUser(temp);
      } else if (doneProcess) {
        int doneCount = user.user.doneCount;
        if (statueValue) {
          //true işlemoeri
          doneCount++;
        } else {
          doneCount--;
        }
        await firestore
            .collection('users')
            .doc(user.user.uid)
            .update({'doneCount': doneCount});
        model.User temp = user.user;
        temp.doneCount = doneCount;
        user.setUser(temp);
      }
    } on FirebaseException catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
    }
    return res;
  }

  Future<bool> updateTodayTextDone(
      BuildContext context, bool value, model.User user, int index) async {
    bool res = false;
    String datetimeToCollect = getDatePart();
    try {
      await firestore
          .collection('todaytext')
          .doc(user.uid)
          .collection(datetimeToCollect)
          .doc(index.toString())
          .update({'done': value});
      if (context.mounted) {
        var p = Provider.of<ProviderUser>(context, listen: false);
        var s = p.todayList;
        TodayModel temp = s[index];
        temp.done = value;
        s[index] = temp;
        p.setTodayList(s);
      }
    } on FirebaseException catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
    }
    return res;
  }

  Future<bool> updateTodayTextImportant(
      BuildContext context, bool value, model.User user, int index) async {
    bool res = false;
    String datetimeToCollect = getDatePart();
    try {
      await firestore
          .collection('todaytext')
          .doc(user.uid)
          .collection(datetimeToCollect)
          .doc(index.toString())
          .update({'important': value});
      if (context.mounted) {
        var p = Provider.of<ProviderUser>(context, listen: false);
        var s = p.todayList;
        TodayModel temp = s[index];
        temp.important = value;
        s[index] = temp;
        p.setTodayList(s);
      }
    } on FirebaseException catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
    }
    return res;
  }

  Future<bool> deletetodayTextitem(
      BuildContext context, int index, model.User user) async {
    bool res = false;
    try {
      String datetimeToCollect = getDatePart();
      await firestore
          .collection('todaytext')
          .doc(user.uid)
          .collection(datetimeToCollect)
          .doc(index.toString())
          .delete();


//------------------------------------------------------

      // Silinen belgeden sonraki tüm belgelerin index değerini güncelle
      var document = await FirebaseFirestore.instance
          .collection('todaytext')
          .doc(user.uid)
          .collection(datetimeToCollect)
          .doc(index.toString())
          .get();

      await FirebaseFirestore.instance
          .collection('todaytext')
          .doc(user.uid)
          .collection(datetimeToCollect)
          .where('index', isGreaterThan: document['index'])
          .get()
          .then((snapshot) {
        for (QueryDocumentSnapshot doc in snapshot.docs) {
          doc.reference.update({'index': FieldValue.increment(-1)});
        }
      });

      //-----------------------------------------------




      getFiresoreData(context);

      var allDoc = await firestore
          .collection('todaytext')
          .doc(user.uid)
          .collection(datetimeToCollect)
          .get();






      int count = allDoc.docs.length;
     for(int i=0;i< count; i++){
       await firestore
           .collection('todaytext')
           .doc(user.uid)
           .collection(datetimeToCollect).doc().update({

       });
     }


      if (context.mounted) {
        var p = Provider.of<ProviderUser>(context, listen: false);
        List<TodayModel> todayListTemp = p.todayList;
        todayListTemp.removeAt(index);
        p.setTodayList(todayListTemp);
      }
    } on FirebaseException catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
    }
    return res;
  }
}
