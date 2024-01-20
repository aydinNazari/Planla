import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:planla/controls/firebase/firestore._methods.dart';
import 'package:planla/controls/providersClass/provider_user.dart';
import 'package:planla/controls/providersClass/timer_provider.dart';
import 'package:planla/widgets/home_screen_scafold_widget.dart';
import 'package:provider/provider.dart';
import '../utiles/constr.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool res = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connectionKontrol(context);
  }


  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  Widget getDataFromFirestore(Size size) {
    return FutureBuilder(
      future: FirestoreMethods().getFirestoreData(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return
              const HomeScreenScafoldWidget();
        } else {
          // Veriler çekilirken bir loading gösterin
          return Center(
            child: SizedBox(
                width: size.width,
                child: Lottie.asset('assets/json/loading.json')),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    ProviderUser providerUser=Provider.of<ProviderUser>(context,listen: false);
    TimerProvider timerProvider=Provider.of<TimerProvider>(context,listen: false);
    return WillPopScope(
      onWillPop: () async {
        logOutFunc(context, size, false,providerUser,timerProvider);
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
}
