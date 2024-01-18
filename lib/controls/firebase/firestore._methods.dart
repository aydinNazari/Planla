import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planla/models/arrangment_model.dart';
import 'package:planla/models/text_id_mode.dart';
import 'package:planla/models/today_model.dart';
import 'package:planla/models/user.dart';
import 'package:planla/utiles/constr.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../models/events_model.dart';
import '../providersClass/provider_user.dart';
import '../providersClass/timer_provider.dart';

class FirestoreMethods {
  Future<void> textSave(BuildContext context, TodayModel todayModel) async {
    List<TodayModel> todayList = [];
    List<TodayModel> tankList = [];
    List<String> idlist = [];
    ProviderUser providerUser =
        Provider.of<ProviderUser>(context, listen: false);
    var uuid = const Uuid();
    var id = uuid.v4();
    try {
      todayModel.textUid = id;
      firestore
          .collection('text')
          .doc(providerUser.user.uid)
          .collection(id)
          .doc(providerUser.user.uid)
          .set(todayModel.toMap());
      idlist = providerUser.getIdList;
      idlist.add(id);
      providerUser.setIdList(idlist);
      TextIds textIds = TextIds(idlist: idlist);
      firestore
          .collection('textIds')
          .doc(providerUser.user.uid)
          .set(textIds.toMap());
      todayList = providerUser.getTodayList;
      tankList = providerUser.getTankList;
      todayList.add(todayModel);
      tankList.add(todayModel);
      providerUser.setTankList(tankList);
      providerUser.setTodayList(todayList);
    } on FirebaseException catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
    }
  }

  Future<void> getFirestoreData(BuildContext context) async {
    ProviderUser providerUser =
        Provider.of<ProviderUser>(context, listen: false);
    TimerProvider timerProvider =
        Provider.of<TimerProvider>(context, listen: false);
    if (providerUser.getControlFirestore) {
      List<String> textIdsList = [];
      try {
        //get score
        DocumentSnapshot cred = await firestore
            .collection('users')
            .doc(providerUser.user.uid)
            .get();
        double tempScore = (cred.data() as dynamic)['score'];
        providerUser.setScore(tempScore);

        //get textIds list
        var snapshot1 = await firestore
            .collection('textIds')
            .doc(providerUser.user.uid)
            .get();
        if (snapshot1.exists) {
          textIdsList = List<String>.from(snapshot1.data()?['idlist'] ?? []);
          providerUser.setIdList(textIdsList);
        } else {
          print('empty do list!');
        }
        List<TodayModel> tankList = [];
        for (int i = 0; i < textIdsList.length; i++) {
          var snapshot = await firestore
              .collection('text')
              .doc(providerUser.user.uid)
              .collection(textIdsList[i])
              .get();
          if (snapshot.docs.isNotEmpty) {
            for (var document in snapshot.docs) {
              TodayModel todayModel = TodayModel(
                text: document['text'],
                dateTime: document['dateTime'],
                done: document['done'],
                important: document['important'],
                typeWork: document['typeWork'],
                email: document['email'],
                textUid: document['textUid'],
                firestorId: document['firestorId'],
              );
              tankList.add(todayModel);
            }
          }
        }
        List<TodayModel> todayList = [];
        List<TodayModel> tempList = [];
        for (int i = 0; i < tankList.length; i++) {
          String timestamp = _twoDigits(tankList[i].dateTime);
          if (getDatePart() == timestamp) {
            todayList.add(tankList[i]);
          }
          if (tankList[i].done) {
            tempList.add(tankList[i]);
          }
        }
        providerUser.setTankList(tankList);
        providerUser.setTodayList(todayList);
        providerUser.setDoneList(tempList);
        providerUser.setControlFirestore(false);

        timerProvider.setMotivitionSentences(motivationSentencesList[
            timerProvider.setRandomNumber(motivationSentencesList.length)]);
        timerProvider.setMotivationLottieUrl(motivationLottieList[
            timerProvider.setRandomNumber(motivationLottieList.length)]);

        // events get
        var eventSnap = await firestore
            .collection('events')
            .doc(providerUser.user.uid)
            .get();

        if (eventSnap.exists) {
          Map<String, dynamic>? eventData = eventSnap.data();
          if (eventData != null) {
            List<String> stringList = List<String>.from(eventData['eventsKey']);
            List<double> intList = List<double>.from(eventData['eventValue']);
            providerUser.setEventsListString(stringList);
            providerUser.setEventsValueList(intList);
            Map<String, double> tempMap = {};
            for (int i = 0; i < stringList.length; i++) {
              tempMap[stringList[i]] = intList[i];
            }
            providerUser.setMapEvent(tempMap);
          }
        }

        DocumentSnapshot<Map<String, dynamic>> scorsDoc =
        await firestore.collection('arrangement').doc('scors').get();
        Map<String, dynamic> scorsData = scorsDoc.data() ?? {};
        Arrangment arrangement = Arrangment.fromMap(scorsData); // Assuming Arrangment.fromMap accepts a Map<String, dynamic>

// Now you have a single Arrangment object
// If you want a list, you can create a List with a single element
        List<Arrangment> arrangements = [arrangement];
        print(arrangements[0].score);
      } on FirebaseException catch (e) {
        if (context.mounted) {
          showSnackBar(context, e.toString(), Colors.red);
        }
      }
    }
  }

  List<String> getKeys(List<Map<String, dynamic>> dataList) {
    List<String> keys = [];
    for (var data in dataList) {
      keys.addAll(_getKeys(data));
    }

    return keys;
  }

  List<String> _getKeys(Map<String, dynamic> data) {
    List<String> keys = [];

    data.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        keys.addAll(_getKeys(value));
      } else if (value is List) {
        for (var item in value) {
          if (item is Map<String, dynamic>) {
            keys.addAll(_getKeys(item));
          }
        }
      } else {
        keys.add(key);
      }
    });

    return keys;
  }

  Future<void> deleteCard(BuildContext context, String deleteId) async {
    ProviderUser providerUser =
        Provider.of<ProviderUser>(context, listen: false);
    try {
      await firestore
          .collection('text')
          .doc(providerUser.user.uid)
          .collection(deleteId)
          .doc(providerUser.user.uid)
          .delete();

      DocumentReference docRef =
          firestore.collection('textIds').doc(providerUser.user.uid);
      DocumentSnapshot docSnapshot = await docRef.get();
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

      if (data.containsKey('idlist')) {
        List<dynamic> yourList = data['idlist'];
        yourList.removeWhere((item) => item == deleteId);
        await docRef.update({'idlist': yourList});
        print('Liste elemanı başarıyla silindi.');
      } else {
        print('Belirtilen belge veya liste bulunamadı.');
      }

      List<TodayModel> tempList = [];
      List<TodayModel> tankList = [];
      List<TodayModel> todayList = [];
      tankList = providerUser.getTankList;
      todayList = providerUser.getTodayList;
      for (int i = 0; i < tankList.length; i++) {
        if (tankList[i].textUid != deleteId) {
          tempList.add(tankList[i]);
        }
      }
      providerUser.setTankList(tempList);

      List<TodayModel> listt = [];
      for (int i = 0; i < todayList.length; i++) {
        if (todayList[i].textUid != deleteId) {
          listt.add(todayList[i]);
        }
      }
      providerUser.setTodayList(listt);
    } on FirebaseException catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
    }
  }

  Future<void> doneImportantUpdate(BuildContext context, bool typeProcess,
      bool value, String processID) async {
    ProviderUser providerUser =
        Provider.of<ProviderUser>(context, listen: false);
    List<TodayModel> tankList = [];
    List<TodayModel> todayList = [];
    List<TodayModel> doneList = [];
    try {
      //typeProcess==true -> don process
      //typeProcess==false -> important process
      if (typeProcess) {
        firestore
            .collection('text')
            .doc(providerUser.user.uid)
            .collection(processID)
            .doc(providerUser.user.uid)
            .update({'done': value});
        tankList = providerUser.getTankList;
        todayList = providerUser.getTodayList;
        for (int i = 0; i < tankList.length; i++) {
          if (tankList[i].textUid == processID) {
            tankList[i].done = value;
          }
          if (tankList[i].done) {
            doneList.add(tankList[i]);
          }
        }
        for (int i = 0; i < todayList.length; i++) {
          if (todayList[i].textUid == processID) {
            todayList[i].done = value;
          }
        }

        providerUser.setTankList(tankList);
        providerUser.setTodayList(todayList);
        providerUser.setDoneList(doneList);
      } else {
        firestore
            .collection('text')
            .doc(providerUser.user.uid)
            .collection(processID)
            .doc(providerUser.user.uid)
            .update({'important': value});
        tankList = providerUser.getTankList;
        todayList = providerUser.getTodayList;
        for (int i = 0; i < tankList.length; i++) {
          if (tankList[i].textUid == processID) {
            tankList[i].important = value;
          }
        }
        for (int i = 0; i < todayList.length; i++) {
          if (todayList[i].textUid == processID) {
            todayList[i].important = value;
          }
        }
        providerUser.setTankList(tankList);
        providerUser.setTodayList(todayList);
      }
    } on FirebaseException catch (e) {
      showSnackBar(context, e.toString(), Colors.red);
    }
  }

  /*Future<void> saveEvent(
      BuildContext context, Map<String, dynamic> event) async {
    ProviderUser providerUser =
        Provider.of<ProviderUser>(context, listen: false);
    List<Map<String, dynamic>> tempMapList = [];
    try {
     tempMapList = providerUser.getEventsListMap;
      tempMapList.add(event);
      //EventModel eventModel = EventModel(eventsMap: tempMapList);
      */ /*var snap =
          await firestore.collection('events').doc(providerUser.user.uid).get();
      int alldoc = snap.data()!.length;*/ /*
      await firestore
          .collection('events')
          .doc(providerUser.user.uid)
          .set({
        'eventsMap' : tempMapList
      });
      providerUser.setEventsListMap(tempMapList);

      List<String> keyList = getKeys(tempMapList);
      providerUser.setEventsListString(keyList);
    } on FirebaseException catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
    }
  }*/

  Future<void> saveEvent(BuildContext context, String event) async {
    ProviderUser providerUser =
        Provider.of<ProviderUser>(context, listen: false);
    List<String> tempString = [];
    List<double> eventValue = [];
    bool control = true;
    try {
      tempString = providerUser.getEventsString;
      for (String v in tempString) {
        if (v.toLowerCase() == event.toLowerCase()) {
          control = false;
        }
      }
      if (control) {
        eventValue = providerUser.getEventsValueList;
        tempString.add(event);
        eventValue.add(0);
        EventModel eventModel =
            EventModel(eventsKey: tempString, eventValue: eventValue);
        await firestore
            .collection('events')
            .doc(providerUser.user.uid)
            .set(eventModel.toMap());
        providerUser.setEventsValueList(eventValue);
        providerUser.setEventsListString(tempString);
        Map<String, double> mapEvent = providerUser.getMapEvent;
        for (int i = 0; i < tempString.length; i++) {
          mapEvent[tempString[i]] = eventValue[i];
        }
        providerUser.setMapEvent(mapEvent);
      } else {
        showSnackBar(
            context, 'The event you entered already exists!', Colors.red);
      }
    } on FirebaseException catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
    }
  }

  Future<void> deleteEvent(BuildContext context, int index) async {
    ProviderUser providerUser =
        Provider.of<ProviderUser>(context, listen: false);
    List<String> tempString = [];
    List<double> tempInt = [];
    try {
      tempString = providerUser.getEventsString;
      tempInt = providerUser.getEventsValueList;
      tempString = List.from(tempString)..removeAt(index);
      tempInt = List.from(tempInt)..removeAt(index);
      Map<String, double> tempMap = {};
      for (int i = 0; i < tempString.length; i++) {
        tempMap[tempString[i]] = tempInt[i];
      }
      providerUser.setMapEvent(tempMap);
      print('ssssssssssssssss ${tempMap}');
      EventModel eventModel =
          EventModel(eventsKey: tempString, eventValue: tempInt);
      await firestore
          .collection('events')
          .doc(providerUser.user.uid)
          .update(eventModel.toMap());
      providerUser.setEventsListString(tempString);
      providerUser.setEventsValueList(tempInt);
    } on FirebaseException catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
    }
  }

  Future<void> updateScoreAndEventsValue(BuildContext context) async {
    ProviderUser providerUser =
        Provider.of<ProviderUser>(context, listen: false);
    TimerProvider timerProvider =
        Provider.of<TimerProvider>(context, listen: false);
    try {
      //set score
      double tempHours = timerProvider.getTempScore;
      await firestore
          .collection('users')
          .doc(providerUser.user.uid)
          .update({'score': tempHours});
      providerUser.setScore(tempHours);

      //save event and its value
      double tempTEventTime = timerProvider.getEventTime;
      // print('getEventTime $tempTEventTime');
      String eventTemp = providerUser.getEvent;
      //print('eventTemp : $eventTemp');
      Map<String, double> tempMapEvent = providerUser.getMapEvent;
      for (var entry in tempMapEvent.entries) {
        String key = entry.key;
        double value = entry.value;
        if (key == eventTemp) {
          /* print('key : $key');
          print('value $value');*/
          tempTEventTime += value;
          String stringValue = tempTEventTime.toString();
          RegExp regex = RegExp(r'^\d*\.\d{0,2}');
          RegExpMatch? match = regex.firstMatch(stringValue);
          String result = match?.group(0) ?? stringValue;
          tempTEventTime = double.parse(result);
        }
      }
      // print('tempTEventTime $tempTEventTime');
      if (tempMapEvent.containsKey(eventTemp)) {
        tempMapEvent[eventTemp] = tempTEventTime;
      }
      providerUser.setMapEvent(tempMapEvent);
      List<double> tempValuList = [];
      tempValuList.addAll(tempMapEvent.values);
      providerUser.setEventsValueList(tempValuList);
      EventModel eventModel = EventModel(
          eventsKey: providerUser.getEventsString, eventValue: tempValuList);
      await firestore
          .collection('events')
          .doc(providerUser.user.uid)
          .update(eventModel.toMap());
      /* EventModel eventModel=EventModel(eventsKey: eventsKey, eventValue: eventValue);
      await firestore.collection('events').doc(providerUser.user.uid).update(eventModel.toMap());*/
    } on FirebaseException catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
    }
  }

  Future<void> updateUserElements(
      BuildContext context, String bio, String name) async {
    ProviderUser providerUser =
        Provider.of<ProviderUser>(context, listen: false);
    try {
      User user = User(
        uid: providerUser.user.uid,
        email: providerUser.user.email,
        name: name != '' ? name : providerUser.user.name,
        imageurl: providerUser.user.imageurl,
        score: providerUser.user.score,
        bio: bio != '' ? bio : providerUser.user.bio,
      );
      await firestore.collection('users').doc(user.uid).update(user.toMap());
      providerUser.setUser(user);
    } on FirebaseException catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
    }
  }

  Future<void> updateArrangement(BuildContext context) async {
    ProviderUser providerUser =
        Provider.of<ProviderUser>(context, listen: false);
    try {
      Map<String, Arrangment> mapArrangment = providerUser.getMapArrangment;
      double score = providerUser.getScore;
      Arrangment? arrangment1 = mapArrangment['1'];
      Arrangment? arrangment2 = mapArrangment['2'];
      Arrangment? arrangment3 = mapArrangment['3'];
      if (arrangment1!.score > score) {
        arrangment1 = Arrangment(
            imgUrl: providerUser.user.imageurl,
            uid: providerUser.user.uid,
            name: providerUser.user.name,
            score: score);
        await firestore
            .collection('arrangement')
            .doc('scors')
            .update({'1': arrangment1});
      } else if (arrangment2!.score > score) {
        arrangment2 = Arrangment(
            imgUrl: providerUser.user.imageurl,
            uid: providerUser.user.uid,
            name: providerUser.user.name,
            score: score);
        await firestore
            .collection('arrangement')
            .doc('scors')
            .update({'2': arrangment2});
      } else if (arrangment3!.score > score) {
        arrangment3 = Arrangment(
            imgUrl: providerUser.user.imageurl,
            uid: providerUser.user.uid,
            name: providerUser.user.name,
            score: score);
        await firestore
            .collection('arrangement')
            .doc('scors')
            .update({'3': arrangment3});
      }
    } on FirebaseException catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
    }
  }

  String _twoDigits(Timestamp timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
            timestamp.seconds * 1000,
            isUtc: true)
        .add(Duration(microseconds: timestamp.nanoseconds ~/ 1000));

    String formattedDate =
        "${dateTime.year}-${_ddd(dateTime.month)}-${_ddd(dateTime.day)} "
        "${_ddd(dateTime.hour)}:${_ddd(dateTime.minute)}:${_ddd(dateTime.second)}";
    formattedDate = formattedDate.substring(0, 10);
    return formattedDate;
  }

  _ddd(int n) {
    if (n >= 10) {
      return "$n";
    } else {
      return "0$n";
    }
  }

  String getDatePart() {
    // " " karakterinden önceki kısmı al
    DateTime dateTime = DateTime.now();
    int spaceIndex = (dateTime.toString()).indexOf(" ");
    String datePart = (dateTime.toString()).substring(0, spaceIndex);
    return datePart;
  }

  Timestamp getTimeStamp() {
    DateTime dateTime = DateTime.now();
    Timestamp timestamp = Timestamp.fromDate(dateTime);
    return timestamp;
  }
}
