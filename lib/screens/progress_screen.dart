import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:planla/screens/home_screen.dart';
import 'package:planla/screens/navigator_screen.dart';

import '../controls/firebase/firestore._methods.dart';
import '../widgets/home_screen_scafold_widget.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return getDataFromFirestore(size);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget getDataFromFirestore(Size size) {
    return FutureBuilder(
      future: FirestoreMethods().getFirestoreData(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const NavigatorScreen();
        } else {
          return Center(
            child: SizedBox(
                width: size.width,
                child: Lottie.asset('assets/json/loading.json')),
          );
        }
      },
    );
  }
}
