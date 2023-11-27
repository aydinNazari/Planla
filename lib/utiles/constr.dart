import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


//navigator pages
List<Widget> screenList = [
  const Center(
    child: Text('HomePage'),
  ),
  const Center(
    child: Text('Add'),
  ),
  const Center(
    child: Text('Analize'),
  ),
  const Center(
    child: Text('Profiile'),
  ),
];

//firebase instances
FirebaseAuth auth=FirebaseAuth.instance;
FirebaseFirestore firestore=FirebaseFirestore.instance;
FirebaseStorage firebaseStorage=FirebaseStorage.instance;


showSnackBar(BuildContext context, String txt, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        txt,
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 2,),
    ),
  );
}


//for picking photo
Future<Uint8List?>pickImager() async {
  FilePickerResult? pickedImage =
  await FilePicker.platform.pickFiles(type: FileType.image);
  if(kIsWeb){
    return pickedImage?.files.single.bytes;
  }
  if(pickedImage!=null){
    return await File(pickedImage.files.single.path!).readAsBytes();
  }
  return null;
}