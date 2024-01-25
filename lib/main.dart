import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:planla/controls/providersClass/provider_user.dart';
import 'package:planla/controls/providersClass/timer_provider.dart';
import 'package:planla/screens/login_signin_screen.dart';
import 'package:planla/screens/navigator_screen.dart';
import 'package:planla/screens/select_language_screen.dart';
import 'package:planla/utiles/constr.dart';
import 'package:provider/provider.dart';
import 'controls/firebase/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProviderUser(),
        ),
        ChangeNotifierProvider(
          create: (_) => TimerProvider(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
   ProviderUser providerUser=Provider.of<ProviderUser>(context,listen: false);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TargetToTarget',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)
            .copyWith(background: const Color(0xffffffff)),
      ),
      home: FutureBuilder(
        future: Auth()
            .getCurrentUser(
            auth.currentUser != null ? auth.currentUser!.uid : null)
            .then((value) {
            Provider.of<ProviderUser>(context, listen: false).setUser(value);
          return value;
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
           return const NavigatorScreen();
          }
          return const LoginSignInScreen();
        },
      ),
    );
  }
}