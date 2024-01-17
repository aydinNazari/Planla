import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planla/utiles/constr.dart';

class Storage{
/*  Future<String> uploadImageToStorage(
      Uint8List? file, String uid) async {
    String downloadUrl='';
    if(file.isNotEmpty){
      Reference ref = firebaseStorage.ref().child('profilephotos').child(uid);
      UploadTask uploadTask = ref.putData(
        file,
        SettableMetadata(
          contentType: 'image/jpg',
        ),
      );
      TaskSnapshot snap = await uploadTask;
      downloadUrl = await snap.ref.getDownloadURL();
    }
    return downloadUrl;
  }*/
  Future<String> uploadImageToStorage(Uint8List? file, String uid) async {
    String downloadUrl = '';

    if (file != null && file.isNotEmpty) {
      try {
        Reference ref = firebaseStorage.ref().child('profilephotos').child(uid);
        UploadTask uploadTask = ref.putData(
          file,
          SettableMetadata(
            contentType: 'image/jpg',
          ),
        );
        TaskSnapshot snap = await uploadTask;
        downloadUrl = await snap.ref.getDownloadURL();
      } catch (error) {
        print("Dosya yüklenirken bir hata oluştu: $error");
      }
    }

    return downloadUrl;
  }

  Future<void> deleteProfilePhoto(BuildContext context,String uid)async{
    try{
      Reference ref = firebaseStorage.ref().child('profilephotos').child(uid);
      await ref.delete();
      await firestore.collection('users').doc(uid).update({
        'imageurl' : ''
      });
    }on FirebaseException catch(e){
      if(context.mounted){
        showSnackBar(context, e.toString(), Colors.red);
      }
    }
  }

}