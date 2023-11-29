import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:planla/screens/profile_screen.dart';

import '../screens/home_screen.dart';

//navigator pages
List<Widget> screenList = [
  const HomeScreen(),
  const Center(
    child: Text('Add'),
  ),
  const Center(
    child: Text('Analize'),
  ),
  const ProfileScreen()
];

//firebase instances
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseStorage firebaseStorage = FirebaseStorage.instance;

showSnackBar(BuildContext context, String txt, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        txt,
      ),
      backgroundColor: color,
      duration: const Duration(
        seconds: 2,
      ),
    ),
  );
}

//for picking photo
Future<Uint8List?> pickImager() async {
  FilePickerResult? pickedImage =
      await FilePicker.platform.pickFiles(type: FileType.image);
  if (kIsWeb) {
    return pickedImage?.files.single.bytes;
  }
  if (pickedImage != null) {
    return await File(pickedImage.files.single.path!).readAsBytes();
  }
  return null;
}

//dialog
Future<void> showMyDialog(BuildContext context, String txt,
    void Function() yesFunction, void Function() noFunction) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Warning',
          style: TextStyle(
              color: const Color(0xffe01c38),
              fontSize: MediaQuery.of(context).size.width / 20,
              fontWeight: FontWeight.w600),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(txt),
              //Text('Would you like to approve of this message?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(onPressed: yesFunction, child: const Text('Yes')),
          TextButton(onPressed: noFunction, child: const Text('No')),
        ],
      );
    },
  );
}

//progress lottie
void lottieProgressDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 2.2,
          height: MediaQuery.of(context).size.width / 2.2,
          child: Lottie.asset('assets/json/progress.json'),
        ),
      );
    },
  );
}
