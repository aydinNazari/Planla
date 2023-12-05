import 'package:flutter/foundation.dart';
import 'package:planla/models/today_model.dart';

import '../../models/user.dart';

class ProviderUser with ChangeNotifier {
  User _user = User(uid: '', email: '', name: '', imageurl: '',doneCount: 0,taskCount:0);
  List<TodayModel> _todayList=[];


  User get user => _user;

  List<TodayModel> get todayList=>_todayList;

  setUser(User user) {
    _user = user;
    notifyListeners();
  }

  setstat(){
    notifyListeners();
  }


  setTodayList(List<TodayModel> todayModelList){
    _todayList=todayModelList;
    notifyListeners();
  }

}