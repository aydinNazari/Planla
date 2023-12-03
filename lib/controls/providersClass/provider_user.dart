import 'package:flutter/foundation.dart';
import 'package:planla/models/today_model.dart';

import '../../models/user.dart';

class ProviderUser with ChangeNotifier {
  User _user = User(uid: '', email: '', username: '', imageurl: '');
   /*TodayModel _todayModel = TodayModel(text: '',
      dateTime: DateTime.now(),
      done: false,
      important: false,
      typeWork: '');*/
   List<TodayModel> _todayList=[];

  User get user => _user;
  //TodayModel get todayModel=>_todayModel;
  List<TodayModel> get todayList=>_todayList;

  setUser(User user) {
    _user = user;
    notifyListeners();
  }

  setStateProvider(){
    notifyListeners();
  }

  /*setTodayModel(TodayModel todayModel){
    _todayModel=todayModel;
    notifyListeners();
  }*/

  setTodayList(List<TodayModel> todayModelList){
    _todayList=todayModelList;
    print('addTodayListtttttttttttttttttttt ProviderUser class');
    print(_todayList.length);
    notifyListeners();
  }

}