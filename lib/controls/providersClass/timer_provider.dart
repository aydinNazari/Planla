import 'dart:async';

import 'package:flutter/material.dart';

class TimerProvider with ChangeNotifier {
  Timer? timer;
  Duration duration = const Duration();
  int _hours = 0;
  int _minute = 0;
  int _secends = 0;
  bool _timerScreenType=true;
  static Duration countdownDuration = const Duration();

  int get getHours=>_hours;
  int get getMinute=>_minute;
  int get getSecends=>_secends;

  Duration get getDuration=>duration;
  bool get timerScreenType=>_timerScreenType;

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
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
    notifyListeners();
  }

  stop({bool resets = true}) {
    if (resets) {
      reset();
    }
    timer?.cancel();
    notifyListeners();
  }

  reset() {
    countdownDuration = Duration(
        minutes: _minute, seconds: _secends, hours: _hours);
    duration = countdownDuration;
    //notifyListeners();
  }

  setHours(int hours){
    _hours=hours;
    notifyListeners();
  }
  setMinute(int minute){
    _minute=minute;
    notifyListeners();
  }
  setSecends(int secends){
    _secends=secends;
    notifyListeners();
  }
  setTimerScreenType(bool type){
    _timerScreenType=type;
    notifyListeners();
  }
}
