import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planla/models/today_model.dart';
import 'package:planla/utiles/constr.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart' as model;
import '../providersClass/provider_user.dart';

class FirestoreMethods {
  Future<bool> firestoreUpload(BuildContext context, ProviderUser user,
      TodayModel todayModel, String id) async {
    bool res = false;
    try {
      String datetimeToCollect = getDatePart();
      /* var allDoc = await firestore
          .collection('todaytext')
          .doc(user.user.uid)
          .collection(datetimeToCollect)
          .get();
      int count = allDoc.docs.length;*/

      await firestore
          .collection('todaytext')
          .doc(user.user.uid)
          .collection(datetimeToCollect)
          .doc(/*count.toString()*/ id)
          .set(todayModel.toMap());
      if (context.mounted) {
        res = await updateTank(context, user, todayModel, true, id);
      }
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
        String firestorId = data['firestorId'] ?? '';

        TodayModel todayModel = TodayModel(
            text: text,
            dateTime: dateTime,
            done: done,
            important: important,
            typeWork: typeWork,
            email: user.email,
            textUid: user.uid,
            firestorId: firestorId);

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

  Future<void> updateTodayTextDone(BuildContext context, bool value,
      ProviderUser providerUser, TodayModel todayModel) async {
    String datetimeToCollect = getDatePart();
    try {
      await firestore
          .collection('todaytext')
          .doc(providerUser.user.uid)
          .collection(datetimeToCollect)
          .doc(todayModel.textUid)
          .update({'done': value});

      String firestoreId='';
      List<TodayModel> tempList = [];
      tempList = providerUser.getTankList;
      for (int i = 0; i > tempList.length; i++) {
        if (tempList[i].textUid == todayModel.textUid) {
          firestoreId=tempList[i].firestorId;
        }
      }

      await firestore
          .collection('tank')
          .doc(providerUser.user.uid)
          .collection(todayModel.textUid)
          .doc(firestoreId)
          .update({'done': value});
    } on FirebaseException catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
    }
  }

  Future<void> updateTodayTextImportant(BuildContext context, bool value,
      ProviderUser providerUser, TodayModel todayModel) async {
    String datetimeToCollect = getDatePart();
    try {
      await firestore
          .collection('todaytext')
          .doc(providerUser.user.uid)
          .collection(datetimeToCollect)
          .doc(todayModel.textUid)
          .update({'important': value});

      String firestoreId='';
      List<TodayModel> tempList = [];
      tempList = providerUser.getTankList;
      for (int i = 0; i > tempList.length; i++) {
        if (tempList[i].textUid == todayModel.textUid) {
          firestoreId=tempList[i].firestorId;
        }
      }

      await firestore
          .collection('tank')
          .doc(providerUser.user.uid)
          .collection(todayModel.textUid)
          .doc(firestoreId)
          .update({'important': value});
    } on FirebaseException catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
    }
  }

  Future<bool> deletetodayTextitem(BuildContext context,
      ProviderUser providerUser, TodayModel todayModel) async {
    bool res = false;
    List<TodayModel> todayModelListTemp = [];
    List<TodayModel> todayModelListTemp2 = [];
    try {
      //String datetimeToCollect = getDatePart();
      todayModelListTemp = providerUser.getTodayList;
      for (int i = 0; i < todayModelListTemp.length; i++) {
        if (todayModelListTemp[i].textUid != todayModel.textUid) {
          todayModelListTemp2.add(todayModelListTemp[i]);
        }
      }
      providerUser.setTodayList(todayModelListTemp2);
      await updateTank(
          context, providerUser, todayModel, false, todayModel.textUid);
      /* todayModelListTemp.clear();
      todayModelListTemp2.clear();
      await firestore
          .collection('todaytext')
          .doc(providerUser.user.uid)
          .collection(datetimeToCollect)
          .doc(todayModel.textUid)
          .delete();*/
      res = true;
    } on FirebaseException catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
      print(e.toString());
    }
    return res;
  }

  Future<bool> updateTank(BuildContext context, ProviderUser providerUser,
      TodayModel todayModel, bool type, String id) async {
    //type==1 -> add
    //type==0 -> delete
    bool res = false;

    List<TodayModel> tempModelList = [];
    if (type) {
      try {
        tempModelList.clear();
        var documentReference = await firestore
            .collection('tank')
            .doc(providerUser.user.uid)
            .collection(id)
            .add(todayModel.toMap());
        var documentId = documentReference.id;
        todayModel.firestorId = documentId;
        await firestore
            .collection('tank')
            .doc(providerUser.user.uid)
            .collection(id)
            .doc(documentId)
            .set(todayModel.toMap());
        tempModelList = providerUser.getTankList;
        tempModelList.add(todayModel);
        providerUser.setTankList(tempModelList);
        res = true;
      } on FirebaseException catch (e) {
        if (context.mounted) {
          showSnackBar(context, e.toString(), Colors.red);
        }
      }
    } else {
      try {
        // delet process
        await firestore
            .collection('tank')
            .doc(providerUser.user.uid)
            .collection(id)
            .get()
            .then((querySnapshot) {
          for (var doc in querySnapshot.docs) {
            doc.reference.delete();
          }
        });
        tempModelList.clear();
        List<TodayModel> tempModelList2 = [];
        tempModelList = providerUser.getTankList;
        for (int i = 0; i < tempModelList.length; i++) {
          if (tempModelList[i].textUid != id) {
            tempModelList2.add(tempModelList[i]);
          }
        }
        providerUser.setTankList(tempModelList2);
        res = true;
      } on FirebaseException catch (e) {
        if (context.mounted) {
          showSnackBar(context, e.toString(), Colors.red);
        }
      }
    }
    return res;
  }
}
