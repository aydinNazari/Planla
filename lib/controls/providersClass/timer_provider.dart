import 'dart:async';

import 'package:flutter/material.dart';

class TimerProvider with ChangeNotifier {
  Timer? timer;
  Duration duration = const Duration();
  int _hours = 0;
  int _minute = 0;
  int _secends = 0;
  bool _timerScreenType = true;

  String _denemeSecend = '';
  String _denemeMinute = '';
  String _denemeHours = '';
  static Duration countdownDuration = const Duration();
  int _counter = 0;


  int get getHours => _hours;

  int get getMinute => _minute;

  int get getSecends => _secends;

  int get getCounter => _counter;

  String get getdenemeSecend => _denemeSecend;

  String get getdenemeMinute => _denemeMinute;

  String get getdenemeHours => _denemeHours;

  Duration get getDuration => duration;

  bool get timerScreenType => _timerScreenType;

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  String getRemainingHours() {
    return twoDigits(duration.inHours);
  }

  String getRemainingMinutes() {
    return twoDigits(duration.inMinutes.remainder(60));
  }

  String getRemainingSeconds() {
    return twoDigits(duration.inSeconds.remainder(60));
  }

  addTime() {
    const addSecend = -1;
    final secend = duration.inSeconds + addSecend;
    if (secend < 0) {
      timer?.cancel();
    } else {
      duration = Duration(seconds: secend);
    }
    notifyListeners();
  }

  void startTime({bool resets = true}) {
    if (resets) {
      reset();
    }
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      addTime();
      _counter--;
      // secend2
      //int temp = 0;
      /* temp = counter ~/ 60; //minute
      _denemeMinute = temp.toString();
      int intTemp=int.parse(_denemeMinute);
      temp=intTemp~/60;
      _denemeHours = temp.toString();
      _denemeSecend=secend2.toString();*/
      int saat = _counter ~/ 3600;
      int dakika = (_counter % 3600) ~/ 60;
      int saniye = _counter % 60;

      _denemeHours = saat.toString();
      _denemeMinute = dakika.toString();
      _denemeSecend = saniye.toString();

      if (_denemeSecend.length < 2) {
        _denemeSecend = '0$_denemeSecend';
      }
      if (_denemeMinute.length < 2) {
        _denemeMinute = '0$_denemeMinute';
      }
      if (_denemeHours.length < 10) {
        _denemeHours = '0$_denemeHours';
      }
      /* if(saniye>59){
        _denemeSecend='00';
        saniye=0;
      }*/
      if (_counter < 1) {
        setTimerReset('00');
      }
      notifyListeners();
    });
  }

  stop({bool resets = true}) {
    if (resets) {
      reset();
    }
    timer?.cancel();
    notifyListeners();
  }

  reset() {
    countdownDuration =
        Duration(minutes: _minute, seconds: _secends, hours: _hours);
    duration = countdownDuration;
    //notifyListeners();
  }

  setHours(int hours) {
    _hours = hours;
    _counter += hours * 3600;
    notifyListeners();
  }

  setMinute(int minute) {
    _minute = minute;
    _counter += minute * 60;
    notifyListeners();
  }

  setSecends(int secends) {
    _secends = secends;
    _counter += secends;
    notifyListeners();
  }

  setTimerScreenType(bool type) {
    _timerScreenType = type;
    notifyListeners();
  }

  setTimerReset(String value) {
    _denemeSecend = value;
    _denemeHours = value;
    _denemeMinute = value;
    _counter = 0;
    //  secend2=0;
    notifyListeners();
  }
}
