import 'package:flutter/foundation.dart';
import 'package:planla/models/arrangment_model.dart';
import 'package:planla/models/today_model.dart';
import '../../models/user.dart';

class ProviderUser with ChangeNotifier {
  User _user = User(
      uid: '',
      email: '',
      name: '',
      imageurl: '',
      score: 0,
      bio: '',
      language: '');
  List<TodayModel> _todayList = [];
  List<TodayModel> _tankList = [];
  List<String> _idList = [];
  bool _controlGetFirestore = true;
  List<TodayModel> _doneList = [];
  List<double> _eventsvalueList = [];
  List<String> _eventsListString = [];
  List<bool> _checkBoxList = [];
  String _event = '';
  double _score = 0;
  double _valueEvent = 0;
  int _index = 0;
  Map<String, double> _mapEvent = {};
  Map<String, Arrangment> _mapArrrangment = {};
  bool _language = false; //language ? Turkey : English
/*
  bool __enterControl =
      false; //_enter ? NavigatorScreeen : SelectLanguageScreen yanı tanıtım ve dil seçimi olacak eğer false ise
*/
  bool _settingLanControl =
  false; //settingLanControl ? update buttonu çalışacak false ise çalışmayacak


  User get user => _user;

  bool get getLanguage => _language;

  /*bool get getEnterControl => __enterControl;*/

  List<TodayModel> get getTodayList => _todayList;

  List<TodayModel> get getTankList => _tankList;

  List<String> get getIdList => _idList;

  bool get getControlFirestore => _controlGetFirestore;

  List<TodayModel> get getDoneList => _doneList;

  List<double> get getEventsValueList => _eventsvalueList;

  List<String> get getEventsString => _eventsListString;

  List<bool> get getCheckBoxList => _checkBoxList;

  String get getEvent => _event;

  double get getValueEvent => _valueEvent;

  int get getIndex => _index;

  Map<String, double> get getMapEvent => _mapEvent;

  Map<String, Arrangment> get getMapArrangment => _mapArrrangment;

bool get getSettingLanControl=>_settingLanControl;

  double get getScore {
    return _score;
  }

  setControlFirestore(bool control) {
    _controlGetFirestore = control;
    notifyListeners();
  }

  setUser(User user) {
    _user = user;
    notifyListeners();
  }

  setTodayList(List<TodayModel> todayModelList) {
    _todayList = todayModelList;
    notifyListeners();
  }

  setTankList(List<TodayModel> taskList) {
    _tankList = taskList;
    notifyListeners();
  }

  setIdList(List<String> idList) {
    _idList = idList;
    notifyListeners();
  }

  setDoneList(List<TodayModel> doneList) {
    _doneList = doneList;
    notifyListeners();
  }

  setEventsValueList(List<double> list) {
    _eventsvalueList = list;
    notifyListeners();
  }

  setEventsListString(List<String> list) {
    _eventsListString = list;
    notifyListeners();
  }

  setCheckBoxList(List<bool> list, bool control) {
    _checkBoxList = list;
    if (control) {
      notifyListeners();
    }
  }

  setEvent(String event, bool control) {
    _event = event;
    if (control) {
      notifyListeners();
    }
  }

  setScore(double s) {
    _score = s;
    notifyListeners();
  }

  setValueEvent(double v) {
    _valueEvent = v;
  }

  setIndex(int v) {
    _index = v;
  }

  setMapEvent(Map<String, double> map) {
    _mapEvent = map;
  }

  setMapArrangment(Map<String, Arrangment> map) {
    _mapArrrangment = map;
    notifyListeners();
  }

  setLanguage(bool v) {
    _language = v;
    //notifyListeners();
  }

/* setEnterControl(bool v) {
    __enterControl = v;
  }*/

setSettingLanControl(bool v){
  _settingLanControl=v;
  notifyListeners();
}
}
