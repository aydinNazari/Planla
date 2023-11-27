import 'package:flutter/foundation.dart';

import '../models/user.dart';

class ProviderUser with ChangeNotifier{


  User _user=User(uid: '', email: '', username: '',imageurl: '');
  User get user =>_user;
  setUser(User user){
    _user=user;
    notifyListeners();
  }

}