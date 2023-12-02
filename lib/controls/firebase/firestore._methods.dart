import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:planla/models/today_model.dart';
import 'package:planla/utiles/constr.dart';

import '../../models/user.dart'as model;

class FirestoreMethods{
    late TodayModel todayModel;
    Future<bool> firestoreUpload(BuildContext context,model.User user,TodayModel todayModel)async{
      bool res=false;
      try{
        await firestore
            .collection('todaytext')
            .doc(user.uid)
            .set(todayModel.toMap());
        res=true;
      }on FirebaseException catch(e){
        showSnackBar(context, e.toString(), Colors.red);
        print(e.toString());
      }

      return res;
    }
}