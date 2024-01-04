import 'package:flutter/foundation.dart';
import 'package:planla/models/today_model.dart';
import '../../models/user.dart';

class ProviderUser with ChangeNotifier {
  User _user = User(uid: '', email: '', name: '', imageurl: '', score: 0);
  List<TodayModel> _todayList = [];
  List<TodayModel> _tankList = [];
  List<String> _idList = [];
  bool _controlGetFirestore = true;
  List<TodayModel> _doneList = [];
  List<Map<String, dynamic>> _eventsListMap = [];
  List<String> _eventsListString = [];
  List<bool> _checkBoxList = [];
  String _event = '';

  User get user => _user;

  List<TodayModel> get getTodayList => _todayList;

  List<TodayModel> get getTankList => _tankList;

  List<String> get getIdList => _idList;

  bool get getControlFirestore => _controlGetFirestore;

  List<TodayModel> get getDoneList => _doneList;

  List<Map<String, dynamic>> get getEventsListMap => _eventsListMap;

  List<String> get getEventsString => _eventsListString;

  List<bool> get getCheckBoxList => _checkBoxList;

  String get getEvent => _event;

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

  setEventsListMap(List<Map<String, dynamic>> list) {
    _eventsListMap = list;
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
}
