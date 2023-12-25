import 'package:flutter/foundation.dart';
import 'package:planla/controls/providersClass/timer_provider.dart';
import 'package:planla/models/today_model.dart';

import '../../models/user.dart';

class ProviderUser with ChangeNotifier {
  User _user = User(uid: '', email: '', name: '', imageurl: '');
  List<TodayModel> _todayList=[];
  List<TodayModel> _tankList=[];
  List<String> _idList=[];
  bool _controlGetFirestore=true;
  List<TodayModel> _doneList=[];


  User get user => _user;
  List<TodayModel> get getTodayList=>_todayList;
  List<TodayModel> get getTankList=>_tankList;
  List<String> get getIdList=>_idList;
  bool get getControlFirestore=>_controlGetFirestore;
  List<TodayModel> get getDoneList=> _doneList;


  setControlFirestore(bool control){
    _controlGetFirestore=control;
    notifyListeners();
  }
  setUser(User user) {
    _user = user;
    notifyListeners();
  }
  setTodayList(List<TodayModel> todayModelList){
    _todayList=todayModelList;
    notifyListeners();
  }
  setTankList(List<TodayModel> taskList){
    _tankList=taskList;
    notifyListeners();
  }
  setIdList(List<String> idList){
    _idList=idList;
    notifyListeners();
  }
  setDoneList(List<TodayModel> doneList){
    _doneList=doneList;
    notifyListeners();
  }

}