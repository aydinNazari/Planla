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
      email: (cred.data() as dynamic)['email'] ?? '',
      name: (cred.data() as dynamic)['name']?? '',
      imageurl: (cred.data() as dynamic)['imageurl'] ?? '',
      score: (cred.data() as dynamic)['score'] ?? 0.0,
      bio: (cred.data() as dynamic)['bio']?? '',
      language: (cred.data() as dynamic)['language']??'',
    );
    // providerUser.setScore(user.score);
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
      if(!cred.user!.emailVerified){
        cred.user!.sendEmailVerification();
      }
      if (cred.user != null) {
        String image =
            await storage.uploadImageToStorage(profilePhoto, cred.user!.uid);
        model.User user = model.User(
          uid: cred.user!.uid,
          email: email.trim(),
          name: username.trim(),
          imageurl: image,
          score: 0,
          bio: '',
          language: '',
        );
        await firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toMap());
        if (context.mounted) {
          Provider.of<ProviderUser>(context, listen: false).setUser(user);
        }
        res = true;
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.message!, Colors.red);
      }
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

      if (user != null) {
        if (userCredential.additionalUserInfo!.isNewUser) {
          await firestore.collection('users').doc(user.uid).set({
            'email': user.email,
            'uid': user.uid,
            'imageurl': user.photoURL,
            'name': user.displayName,
            'bio': '',
            'language': '',
            'score' : 0.0
          });
        }
        res = true;
      }
      return res;
    } on FirebaseAuthException catch (e) {
      res = false;
      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
    }
    return res;
  }

  Future<bool> loginUser(
      String email, String pass, BuildContext context) async {
    bool res = false;
    try {
      UserCredential cred =
          await auth.signInWithEmailAndPassword(email: email, password: pass);
     // await auth.currentUser!.reload();

      if (cred.user != null) {

        //model.User user=model.User(uid: uid, email: email, username: username);
        model.User user = await getCurrentUser(cred.user!.uid);
        if (context.mounted) {
          Provider.of<ProviderUser>(context, listen: false).setUser(user);
        }
        res = true;
        if (!cred.user!.emailVerified) {
          res=false;
          if (context.mounted) {
            showSnackBar(
                context,
                providerUser.getLanguage
                    ? 'E-postanızı henüz doğrulamadınız. Lütfen e-postanızı doğrulayın'
                    : 'You haven\'t verified your email yet. Please verify your email',
                Colors.red);
          }

        }
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
    }
    return res;
  }
  Future<void> forgetPass(BuildContext context,String email)async{
    try{
      await auth.sendPasswordResetEmail(email: email);
     if(context.mounted){
       showSnackBar(context, 'Please check your email!', Colors.green);
     }
    }on FirebaseException catch(e){
      if(context.mounted){
        showSnackBar(context, e.toString(), Colors.red);
      }
    }
  }
}
