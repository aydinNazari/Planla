import 'package:flutter/foundation.dart';
import 'package:planla/models/today_model.dart';

import '../../models/user.dart';

class ProviderUser with ChangeNotifier {
  User _user = User(uid: '', email: '', name: '', imageurl: '',doneCount: 0,taskCount:0);
  List<TodayModel> _todayList=[];
  List<TodayModel> _doneList=[];
  List<TodayModel> _taskList=[];


  User get user => _user;
  List<TodayModel> get todayList=>_todayList;
  List<TodayModel> get todayDonList=>_doneList;
  List<TodayModel> get todayTaskList=>_taskList;

  setUser(User user) {
    _user = user;
    notifyListeners();
  }

  setTodayList(List<TodayModel> todayModelList){
    _todayList=todayModelList;
    notifyListeners();
  }

  setDonList(List<TodayModel> doneList){
    _doneList=doneList;
    notifyListeners();
  }

  setTaskList(List<TodayModel> taskList){
    _taskList=taskList;
    notifyListeners();
  }

}