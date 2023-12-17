import 'package:flutter/foundation.dart';
import 'package:planla/models/today_model.dart';

import '../../models/user.dart';

class ProviderUser with ChangeNotifier {
  User _user = User(uid: '', email: '', name: '', imageurl: '',doneCount: 0,taskCount:0);
  List<TodayModel> _todayList=[];
  List<TodayModel> _tankList=[];
  List<String> _idList=[];
  bool _controlGetFirestore=true;
  int _doneCount=0;
  int _taskCount=0;
  List<TodayModel> _doneList=[];


  User get user => _user;
  List<TodayModel> get getTodayList=>_todayList;
  List<TodayModel> get getTankList=>_tankList;
  List<String> get getIdList=>_idList;
  bool get getControlFirestore=>_controlGetFirestore;
  int get getDoneCount=> _doneCount;
  int get getTaskCount=> _taskCount;
  List<TodayModel> get getDoneList=> _doneList;


  setControlFirestore(bool control){
    _controlGetFirestore=control;
  }
  setUser(User user) {
    _user = user;
    notifyListeners();
  }
  setTodayList(List<TodayModel> todayModelList){
    _todayList=todayModelList;
    notifyListeners();
  }
  setDoneCount(int s){
    _doneCount=s;
    notifyListeners();
  }
  setTaskCount(int s){
    _taskCount=s;
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