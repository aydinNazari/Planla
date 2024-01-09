import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:planla/utiles/constr.dart';

class TimerProvider with ChangeNotifier {
  Timer? timer;
  Duration duration = const Duration();
  int _hours = 0;
  int _minute = 0;
  int _secends = 0;
  bool _timerScreenType = true;
  int tempCounter = 0;

  String _denemeSecend = '';
  String _denemeMinute = '';
  String _denemeHours = '';
  static Duration countdownDuration = const Duration();
  int _counter = 0;
  double _tempScore = 0;
  String _motivationLottieUrl = '';
  String _motivationSentences = '';
  bool _timerFinishControl = false;

  int get getHours => _hours;

  int get getMinute => _minute;

  int get getSecends => _secends;

  int get getCounter => _counter;

  double get getTempScore => _tempScore;

  String get getdenemeSecend => _denemeSecend;

  String get getdenemeMinute => _denemeMinute;

  String get getdenemeHours => _denemeHours;

  Duration get getDuration => duration;

  bool get timerScreenType => _timerScreenType;

  String get getMotivationLttieUrl => _motivationLottieUrl;

  String get getMotivationSentences => _motivationSentences;

  bool get getTimerFinishControl => _timerFinishControl;

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
    timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      addTime();
      _counter--;
      tempCounter++;
      if (tempCounter == 60) {
        tempCounter = 0;
        int temp = setRandomNumber(motivationLottieList.length);
        setMotivationLottieUrl(motivationLottieList[temp]);
        temp = setRandomNumber(motivationSentencesList.length);
        setMotivitionSentences(motivationSentencesList[temp]);
      }
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
        setTimerFinishControl(true);
        setTimerReset('00');
        setTimerScreenType(true);
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

  setTempScore(double temp) {
    _tempScore = temp / 3600;
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

  setMotivationLottieUrl(String value) {
    _motivationLottieUrl = value;
    notifyListeners();
  }

  setMotivitionSentences(String value) {
    _motivationSentences = value;
    notifyListeners();
  }

  int setRandomNumber(int value) {
    var random = Random();
    return random.nextInt(value);
  }

  void setTimerFinishControl(bool v) {
    _timerFinishControl = v;
    notifyListeners();
  }

}
