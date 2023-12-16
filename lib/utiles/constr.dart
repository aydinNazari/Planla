import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:planla/screens/add_screen.dart';
import 'package:planla/screens/profile_screen.dart';

import '../controls/firebase/auth.dart';
import '../screens/home_screen.dart';
import '../screens/login_signin_screen.dart';

//navigator pages
List<Widget> screenList = [
  const HomeScreen(),
  const AddScreen(),
/*  const Center(
    child: Text('Analize'),
  ),*/
  const ProfileScreen(
    control: false,
  )
];

//dropdown items
final List<String> items = [
  'Study',
  'Work',
  'Sport',
  'other',
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
Future<void> showMyDialog(BuildContext context, Size size, String txt,
    void Function() yesFunction, void Function() noFunction) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              SizedBox(
                width: size.width / 6,
                height: size.width / 6,
                child: Image.asset('assets/images/goals_dialog.png'),
              ),
              SizedBox(
                height: size.height / 50,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width / 25),
                child: Text(txt),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: yesFunction,
                  child: Text(
                    'Yes',
                    style: TextStyle(
                        color: Colors.black, fontSize: size.width / 25),
                  )),
              TextButton(
                  onPressed: noFunction,
                  child: Text(
                    'No',
                    style: TextStyle(
                        color: Colors.black, fontSize: size.width / 25),
                  )),
            ],
          )
        ],
      );
    },
  );
}

//progress lottie
void lottieProgressDialog(BuildContext context,String url) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return Center(
        child: SizedBox(
          width: MediaQuery
              .of(context)
              .size
              .width / 2.2,
          height: MediaQuery
              .of(context)
              .size
              .width / 2.2,
          child: Lottie.asset(url),
        ),
      );
    },
  );
}

Future<void> logOutFunc(BuildContext context, Size size, bool exitType) async {
  // exittype==true -> logOut
  // exittype==false -> exit from app
  if (exitType) {
    showMyDialog(context, size, 'Are you sure you want to log out?', () async {
      await Auth().signOut();
      if(context.mounted){
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.topToBottom,
            child: const LoginSignInScreen(),
          ),
        );
      }
    }, () {
      Navigator.of(context).pop();
    });
  } else {
    showMyDialog(
        context, size, 'Are you sure you want to exit the application??', () {
      exit(0);
    }, () {
      Navigator.of(context).pop();
    });
  }
}

void connectionKontrol(BuildContext context) async {
  final connectivityResult = await (Connectivity().checkConnectivity());
 if (connectivityResult == ConnectivityResult.none) {
   if(context.mounted){
      showSnackBar(
          context, 'Please check your internet connection', Colors.red);
    }
    // I am not connected to any network.
  }

}
