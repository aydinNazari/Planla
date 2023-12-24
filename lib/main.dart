import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:planla/controls/providersClass/provider_user.dart';
import 'package:planla/screens/login_signin_screen.dart';
import 'package:planla/screens/navigator_screen.dart';
import 'package:planla/utiles/constr.dart';
import 'package:provider/provider.dart';
import 'controls/firebase/auth.dart';

final FlutterLocalNotificationsPlugin flutterLocalPlugin =
    FlutterLocalNotificationsPlugin();
const AndroidNotificationChannel notificationChannel =
    AndroidNotificationChannel('coding', 'coding aydin',
        description: 'This is a notificatiiiiiioooooon',
        importance: Importance.high);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSercice();
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

Future<void> initSercice() async {
  var service = FlutterBackgroundService();
  if (Platform.isIOS) {
    //ios cods
  }
  await flutterLocalPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(notificationChannel);
  await service.configure(
      iosConfiguration:
          IosConfiguration(onBackground: iosBackground, onForeground: iosBackground),
      androidConfiguration: AndroidConfiguration(
          onStart: onStart,
          autoStart: true,
          isForegroundMode: true,
          notificationChannelId: 'coding',
          initialNotificationTitle: 'bu bir title dir!',
          initialNotificationContent: 'bu bir contant dir',
          foregroundServiceNotificationId: 90));
  service.startService();
}

@pragma('vm:enry-point')
void onStart(ServiceInstance service) {
  DartPluginRegistrant.ensureInitialized();
  service.on('setAsForeground').listen((event) {
    print('Forgraunddddddddddddddddddddddddddddddddddddddd');
  });
  service.on('setAsBackground').listen((event) {
    print('backGroundddddddddddddddddddddddddddddddddddddd');
  });
  service.on('stopService').listen((event) {
    print('stopppppppppppppppppppppppppppppppppppppppppppp');
    service.stopSelf();
  });
  Timer.periodic(const Duration(seconds: 2), (timer) {
    flutterLocalPlugin.show(
        90,
        'bu flutter title wardaş',
        'buda body dir ${DateTime.now()}',
        const NotificationDetails(
            android: AndroidNotificationDetails(
          'coding',
          'coding aydin',
          ongoing: true,
              icon: 'app_icon'
        )));
  });
}

//ios
@pragma('vm:enry-point')
Future<bool> iosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
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
