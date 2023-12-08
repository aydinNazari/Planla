import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:planla/controls/firebase/storage.dart';
import 'package:planla/controls/providersClass/provider_user.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart' as model;
import '../../utiles/constr.dart';

class Auth {
  ProviderUser providerUser = ProviderUser();
  Storage storage = Storage();

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<model.User> getCurrentUser(String? uid) async {
    DocumentSnapshot cred = await firestore.collection('users').doc(uid).get();
    model.User user = model.User(
        uid: uid!,
        email: (cred.data()! as dynamic)['email'] ?? '',
        name: (cred.data()! as dynamic)['name'] ?? '',
        imageurl: (cred.data()! as dynamic)['imageurl'] ?? '',
        doneCount: (cred.data()! as dynamic)['doneCount'] ?? 0,
      taskCount: (cred.data()! as dynamic)['taskCount'] ?? 0,

    );
    providerUser.setUser(user);
    return user;
  }

  Future<bool> signupUser(String email, String username, String pass,
      BuildContext context, Uint8List? profilePhoto) async {
    bool res = false;
    try {
      UserCredential cred = await auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      if (cred.user != null) {
        String image =
            await storage.uploadImageToStorage(profilePhoto, cred.user!.uid);
        model.User user = model.User(
            uid: cred.user!.uid,
            email: email.trim(),
            name: username.trim(),
            imageurl: image,
            doneCount: 0,
          taskCount: 0
        );
        await firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toMap());
        Provider.of<ProviderUser>(context, listen: false).setUser(user);
        res = true;
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!, Colors.red);
    }
    return res;
  }

  Future<bool> signInWithGoogle(BuildContext context) async {
    bool res = false;
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =
          await auth.signInWithCredential(credential);
      User? user = userCredential.user;
    /*  model.User _user = model.User(
        uid: user!.uid,
        email: user.email!,
        username: user.displayName!,
        imageurl: user.photoURL!,
      );
      providerUser.setUser(_user);
*/
      model.User _user = await getCurrentUser(user!.uid);
      Provider.of<ProviderUser>(context, listen: false).setUser(_user);
      if (user != null) {
        if (userCredential.additionalUserInfo!.isNewUser) {
          await firestore.collection('users').doc(user.uid).set(
            {
              'email': user.email,
              'profilePhoto': user.photoURL,
              'uid': user.uid,
              'username': user.displayName,
              'doneCount': user.displayName,
              'taskCount': user.displayName,
            },
          );
        }
        res = true;
      }
      return res;
    } on FirebaseAuthException catch (e) {
      res = false;
      showSnackBar(context, e.message!, Colors.red);
      print(e.toString());
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
        model.User user = await getCurrentUser(cred.user!.uid);
        Provider.of<ProviderUser>(context, listen: false).setUser(user);
        res = true;
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
    return res;
  }
}
