import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:planla/utiles/constr.dart';

import '../firebase/firestore._methods.dart';

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
  String _motivationSentesEn = '';
  String _motivationSentesTur = '';
  bool _timerFinishControl = false;
  double _eventTime=0.0;

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

  String get getMotivationSentencesEn => _motivationSentesEn;
  String get getMotivationSentencesTur => _motivationSentesTur;

  bool get getTimerFinishControl => _timerFinishControl;

  double get getEventTime =>_eventTime;

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
        temp = setRandomNumber(motivationSentencesEnList.length);
        setMotivitionSentencesEn(motivationSentencesEnList[temp]);
        setMotivitionSentencesTur(motivationSentencesTurList[temp]);
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
      if (_counter <= -1) {
        _counter=0;
        print('gtgtgtgtgtgttgtttggg');
        setTimerFinishControl(true);

        setTimerScreenType(true);
        setTimerFinishControl(true);
        timer?.cancel();
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

  setTempScore() {
    _tempScore += _minute / 60;
    _tempScore += _secends / 3600;
    _tempScore += _hours;
    String stringTemp = _tempScore.toStringAsFixed(2);
    _tempScore = double.parse(stringTemp);
    notifyListeners();
  }

  reseteSvcore(){ //when users want to log out.
    _tempScore=0.0;
  }
  setEventTime() {
    _eventTime=0;
    _eventTime += _minute / 60;
    _eventTime += _secends / 3600;
    _eventTime += _hours;
    String stringValue = _eventTime.toString();
    RegExp regex = RegExp(r'^\d*\.\d{0,2}');
    RegExpMatch? match = regex.firstMatch(stringValue);
    String result = match?.group(0) ?? stringValue;
    _eventTime = double.parse(result);



    //print('setEventTime $_eventTime');
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

  setMotivitionSentencesEn(String value) {
    _motivationSentesEn = value;
    notifyListeners();
  }
  setMotivitionSentencesTur(String value) {
    _motivationSentesTur = value;
    notifyListeners();
  }

  int setRandomNumber(int value) {
    var random = Random();
    return random.nextInt(value);
  }

  void setTimerFinishControl(bool v) {
    _timerFinishControl = v;
   //notifyListeners();
  }
  setScore(double v){
    _tempScore=v;
    notifyListeners();
  }
}
