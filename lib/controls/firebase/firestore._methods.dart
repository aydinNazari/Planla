import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
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
      List<String> idlist = [];
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
      providerUser.setTankList(tankList);
      providerUser.setTodayList(todayList);
    } on FirebaseException catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
    }
  }

  Future<void> getData(BuildContext context) async {
    ProviderUser providerUser =
        Provider.of<ProviderUser>(context, listen: false);
    List<String> textIdsList=[];
    try {
      var snapshot1 = await firestore
          .collection('textIds')
          .doc(providerUser.user.uid)
          .get();
      if (snapshot1.exists) {
          textIdsList= List<String>.from(snapshot1.data()?['idlist'] ?? []);
      } else {
        print('Belge bulunamadı');
      }
      List<TodayModel> tankList=[];
      for(int i=0;i< textIdsList.length;i++){
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
      //task'a bugünün tarihi ise taskListe ekle
      providerUser.setTankList(tankList);
    } on FirebaseException catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
    }
  }
}
