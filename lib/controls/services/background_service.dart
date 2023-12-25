import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class BackgroundService {
  final FlutterLocalNotificationsPlugin flutterLocalPlugin =
      FlutterLocalNotificationsPlugin();
  static const AndroidNotificationChannel notificationChannel =
      AndroidNotificationChannel('coding', 'coding aydin',
          description: 'This is a notificatiiiiiioooooon',
          importance: Importance.high);

  Future<void> initSercice(int hours,int minute,int secend) async {
    FlutterBackgroundService service = FlutterBackgroundService();
    if (Platform.isIOS) {
      //ios cods
    }
    await flutterLocalPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(notificationChannel);
    await service.configure(
        iosConfiguration: IosConfiguration(
            onBackground: iosBackground, onForeground: iosBackground),
        androidConfiguration: AndroidConfiguration(
            onStart: onStart,
            autoStart: true,
            isForegroundMode: true,
            notificationChannelId: 'coding',
            initialNotificationTitle: 'title',
            initialNotificationContent: 'bu bir contant dir',
            foregroundServiceNotificationId: 90));
    service.startService();
    Timer.periodic( Duration(hours: hours,seconds: secend,minutes: minute), (timer) {
      flutterLocalPlugin.show(
          90,
          'bu flutter title wardaş',
          'buda body dir ${DateTime.now()}',
          const NotificationDetails(
              android: AndroidNotificationDetails('coding', 'coding aydin',
                  ongoing: true, icon: 'app_icon')));
    });
  }
}

@pragma('vm:enry-point')
void onStart(ServiceInstance service) {
  DartPluginRegistrant.ensureInitialized();
  print('pppppppppppppoooooooooooooooooooooooooooooooooooooooooooooooooooo');

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
}

//ios
@pragma('vm:enry-point')
Future<bool> iosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}
