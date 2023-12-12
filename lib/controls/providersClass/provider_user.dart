import 'package:flutter/foundation.dart';
import 'package:planla/models/today_model.dart';

import '../../models/user.dart';

class ProviderUser with ChangeNotifier {
  User _user = User(uid: '', email: '', name: '', imageurl: '',doneCount: 0,taskCount:0);
  List<TodayModel> _todayList=[];
  //List<TodayModel> _doneList=[];
  List<TodayModel> _tankList=[];


  User get user => _user;
  List<TodayModel> get getTodayList=>_todayList;
  //List<TodayModel> get todayDonList=>_doneList;
  List<TodayModel> get getTankList=>_tankList;

  setUser(User user) {
    _user = user;
    notifyListeners();
  }

  setTodayList(List<TodayModel> todayModelList){
    _todayList=todayModelList;
    notifyListeners();
  }

  setDoneCount(int s){
    _user.doneCount=s;
    notifyListeners();
  }
  setTaskCount(int s){
    _user.taskCount=s;
    notifyListeners();
  }
/*  setDonList(List<TodayModel> doneList){
    _doneList=doneList;
    notifyListeners();
  }*/

  setTankList(List<TodayModel> taskList){
    _tankList=taskList;
    notifyListeners();
  }

}