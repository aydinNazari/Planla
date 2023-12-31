import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
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

}