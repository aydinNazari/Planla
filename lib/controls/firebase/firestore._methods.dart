import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planla/models/text_id_mode.dart';
import 'package:planla/models/today_model.dart';
import 'package:planla/utiles/constr.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providersClass/provider_user.dart';

class FirestoreMethods {
  Future<void> textSave(BuildContext context, TodayModel todayModel) async {
    List<TodayModel> todayList = [];
    List<TodayModel> tankList = [];
    List<String> idlist = [];
    ProviderUser providerUser =
        Provider.of<ProviderUser>(context, listen: false);
    var uuid = const Uuid();
    var id = uuid.v4();
    try {
      todayModel.textUid = id;
      firestore
          .collection('text')
          .doc(providerUser.user.uid)
          .collection(id)
          .doc(providerUser.user.uid)
          .set(todayModel.toMap());
      idlist = providerUser.getIdList;
      idlist.add(id);
      providerUser.setIdList(idlist);
      TextIds textIds = TextIds(idlist: idlist);
      firestore
          .collection('textIds')
          .doc(providerUser.user.uid)
          .set(textIds.toMap());
      todayList = providerUser.getTodayList;
      tankList = providerUser.getTankList;
      todayList.add(todayModel);
      tankList.add(todayModel);
      providerUser.setTankList(tankList);
      providerUser.setTodayList(todayList);
    } on FirebaseException catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
    }
  }

  Future<void> getFirestoreData(BuildContext context) async {
    ProviderUser providerUser =
        Provider.of<ProviderUser>(context, listen: false);
    List<String> textIdsList = [];
    try {
      //get task and done Count
      DocumentSnapshot cred =
          await firestore.collection('users').doc(providerUser.user.uid).get();
      int doneCount = (cred.data()! as dynamic)['doneCount'] ?? 0;
      int taskCount = (cred.data()! as dynamic)['taskCount'] ?? 0;
      providerUser.setDoneCount(doneCount);
      providerUser.setTaskCount(taskCount);
      //

      //get textIds list
      var snapshot1 = await firestore
          .collection('textIds')
          .doc(providerUser.user.uid)
          .get();
      if (snapshot1.exists) {
        textIdsList = List<String>.from(snapshot1.data()?['idlist'] ?? []);
        providerUser.setIdList(textIdsList);
      } else {
        print('Belge bulunamadı');
      }
      List<TodayModel> tankList = [];
      for (int i = 0; i < textIdsList.length; i++) {
        var snapshot = await firestore
            .collection('text')
            .doc(providerUser.user.uid)
            .collection(textIdsList[i])
            .get();
        if (snapshot.docs.isNotEmpty) {
          // Belge listesini döngüye al
          for (var document in snapshot.docs) {
            TodayModel todayModel = TodayModel(
              text: document['text'],
              dateTime: document['dateTime'],
              done: document['done'],
              important: document['important'],
              typeWork: document['typeWork'],
              email: document['email'],
              textUid: document['textUid'],
              firestorId: document['firestorId'],
            );
            tankList.add(todayModel);
          }
        }
      }

      List<TodayModel> todayList = [];
      List<TodayModel> tempList = [];
      for (int i = 0; i < tankList.length; i++) {
        String timestamp = _twoDigits(tankList[i].dateTime);
        if (getDatePart() == timestamp) {
          todayList.add(tankList[i]);
        }
        if(tankList[i].done){
          tempList.add(tankList[i]);
        }
      }
      providerUser.setTankList(tankList);
      providerUser.setTodayList(todayList);
      providerUser.setDoneList(tempList);




    } on FirebaseException catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
    }
  }

  Future<void> deleteCard(BuildContext context, String deleteId) async {
    ProviderUser providerUser =
        Provider.of<ProviderUser>(context, listen: false);
    try {
      await firestore
          .collection('text')
          .doc(providerUser.user.uid)
          .collection(deleteId)
          .doc(providerUser.user.uid)
          .delete();

      DocumentReference docRef =
          firestore.collection('textIds').doc(providerUser.user.uid);
      DocumentSnapshot docSnapshot = await docRef.get();
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

      if (data.containsKey('idlist')) {
        List<dynamic> yourList = data['idlist'];
        yourList.removeWhere((item) => item == deleteId);
        await docRef.update({'idlist': yourList});
        print('Liste elemanı başarıyla silindi.');
      } else {
        print('Belirtilen belge veya liste bulunamadı.');
      }

      List<TodayModel> tempList = [];
      List<TodayModel> tankList = [];
      List<TodayModel> todayList = [];
      tankList = providerUser.getTankList;
      todayList = providerUser.getTodayList;
      for (int i = 0; i < tankList.length; i++) {
        if (tankList[i].textUid != deleteId) {
          tempList.add(tankList[i]);
        }
      }
      providerUser.setTankList(tempList);
      tempList.clear();
      tempList = [];
      for (int i = 0; i < todayList.length; i++) {
        if (todayList[i].textUid != deleteId) {
          tempList.add(todayList[i]);
        }
      }
      providerUser.setTodayList(tempList);
    } on FirebaseException catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
    }
  }

  Future<void> doneImportantUpdate(BuildContext context, bool typeProcess,
      bool value, String processID) async {
    ProviderUser providerUser =
        Provider.of<ProviderUser>(context, listen: false);
    List<TodayModel> tankList = [];
    List<TodayModel> todayList = [];
    try {
      //typeProcess==true -> don process
      //typeProcess==false -> important process
      if (typeProcess) {
        firestore
            .collection('text')
            .doc(providerUser.user.uid)
            .collection(processID)
            .doc(providerUser.user.uid)
            .update({'done': value});
        tankList = providerUser.getTankList;
        todayList = providerUser.getTodayList;
        for (int i = 0; i < tankList.length; i++) {
          if (tankList[i].textUid == processID) {
            tankList[i].done = value;
          }
        }
        for (int i = 0; i < todayList.length; i++) {
          if (todayList[i].textUid == processID) {
            todayList[i].done = value;
          }
        }
        providerUser.setTankList(tankList);
        providerUser.setTodayList(todayList);
      } else {
        firestore
            .collection('text')
            .doc(providerUser.user.uid)
            .collection(processID)
            .doc(providerUser.user.uid)
            .update({'important': value});
        tankList = providerUser.getTankList;
        todayList = providerUser.getTodayList;
        for (int i = 0; i < tankList.length; i++) {
          if (tankList[i].textUid == processID) {
            tankList[i].important = value;
          }
        }
        for (int i = 0; i < todayList.length; i++) {
          if (todayList[i].textUid == processID) {
            todayList[i].important = value;
          }
        }
        providerUser.setTankList(tankList);
        providerUser.setTodayList(todayList);
      }
    } on FirebaseException catch (e) {
      showSnackBar(context, e.toString(), Colors.red);
    }
  }

  Future<void> userDoneImpotantUpdate(BuildContext context,bool typeProcess,bool decreasIncreasing) async {
    ProviderUser providerUser =
        Provider.of<ProviderUser>(context, listen: false);
    //typeProcess==true -> done process
    //typeProcess==false -> task process
    // decreasIncreasing==false -> -- process
    // decreasIncreasing==true -> ++ process
    try {
      if(typeProcess){
        int doneCount=providerUser.getDoneCount;
        if(decreasIncreasing){
          doneCount++;
        }else{
          doneCount--;
        }
        firestore.collection('users').doc(providerUser.user.uid).update({
          'doneCount' : doneCount
        });
        providerUser.setDoneCount(doneCount);
      }else{
        int taskCount=providerUser.getTaskCount;
        if(decreasIncreasing){
          taskCount++;
        }else{
          taskCount--;
        }
        firestore.collection('users').doc(providerUser.user.uid).update({
          'taskCount' : taskCount
        });
        providerUser.setTaskCount(taskCount);
      }
    } on FirebaseException catch (e) {
      showSnackBar(context, e.toString(), Colors.red);
    }
  }

  String _twoDigits(Timestamp timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
            timestamp.seconds * 1000,
            isUtc: true)
        .add(Duration(microseconds: timestamp.nanoseconds ~/ 1000));

    String formattedDate =
        "${dateTime.year}-${_ddd(dateTime.month)}-${_ddd(dateTime.day)} "
        "${_ddd(dateTime.hour)}:${_ddd(dateTime.minute)}:${_ddd(dateTime.second)}";
    formattedDate = formattedDate.substring(0, 10);
    return formattedDate;
  }

  _ddd(int n) {
    if (n >= 10) {
      return "$n";
    } else {
      return "0$n";
    }
  }

  String getDatePart() {
    // " " karakterinden önceki kısmı al
    DateTime dateTime = DateTime.now();
    int spaceIndex = (dateTime.toString()).indexOf(" ");
    String datePart = (dateTime.toString()).substring(0, spaceIndex);
    return datePart;
  }

  Timestamp getTimeStamp() {
    DateTime dateTime = DateTime.now();
    Timestamp timestamp = Timestamp.fromDate(dateTime);
    return timestamp;
  }
}
