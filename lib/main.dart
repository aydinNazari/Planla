import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:planla/controls/providersClass/provider_user.dart';
import 'package:planla/screens/Intro_screen_page.dart';
import 'package:planla/screens/login_signin_screen.dart';
import 'package:planla/screens/navigator_screen.dart';
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
          if (value != null) {
            Provider.of<ProviderUser>(context, listen: false).setUser(value);
          }
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
