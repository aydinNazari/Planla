import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planla/controls/provider_user.dart';
import 'package:provider/provider.dart';

import '../models/user.dart' as model;
import '../utiles/constr.dart';


class Auth{
  ProviderUser providerUser=ProviderUser();

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<model.User> getCurrentUser(String? uid,String? imageUrl) async {
    DocumentSnapshot cred = await firestore.collection('users').doc(uid).get();
    model.User user = model.User(
        uid: uid!,
        email: (cred.data()! as dynamic)['email'],
        username: (cred.data()! as dynamic)['username'],
        imageurl: (cred.data()! as dynamic)['imageurl']
    );
    providerUser.setUser(user);
    return user;
  }


  Future<bool> signupUser(
      String email, String username, String pass, BuildContext context) async {
    bool res = false;
    try {
      UserCredential cred = await auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      if (cred.user != null) {
        model.User user = model.User(
          uid: cred.user!.uid,
          email: email.trim(),
          username: username.trim(),
          imageurl: ''//buraya image url'i getir
        );
        await firestore.collection('users').doc(cred.user!.uid).set(user.toMap());
        Provider.of<ProviderUser>(context, listen: false).setUser(user);
        res = true;
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!, Colors.red);
    }
    return res;
  }

  Future<bool> loginUser(
      String email, String pass, BuildContext context) async {
    bool res = false;
    try {
      UserCredential cred =
      await auth.signInWithEmailAndPassword(email: email, password: pass);
      if (cred.user != null) {
        //model.User user=model.User(uid: uid, email: email, username: username);
        model.User user = await getCurrentUser(cred.user!.uid,cred.user!.photoURL);
        Provider.of<ProviderUser>(context, listen: false).setUser(user);
        res = true;
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
    return res;
  }
}