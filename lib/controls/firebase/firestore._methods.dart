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
  Future<bool> getLanguage(BuildContext context) async {
    bool value = false;
    ProviderUser providerUser = Provider.of<ProviderUser>(context,listen: false);
    try {
      var snap = await firestore.collection('users')
          .doc(providerUser.user.uid)
          .get();
      String lang = (snap.data() as dynamic)['language'];
      if (lang.isNotEmpty) {
        value = true;
      }
      if(lang =='Tur'){
       providerUser.setLanguage(true);
     }else if(lang=='En'){
       providerUser.setLanguage(false);
     }
    } on FirebaseException catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
    }
    return value;
  }

  Future<void> setLanguage(BuildContext context,String lang) async {
    ProviderUser providerUser = Provider.of<ProviderUser>(context,listen: false);
    String lan='';
    try {
      if(lang=='Türkçe'){
        lan='Tur';
      }else{
        lan='En';
      }
      await
      firestore.collection('users').doc(providerUser.user.uid).update({
        'language' : lan
      });
    } on FirebaseException catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
    }
  }


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
        timerProvider.setScore(tempScore);

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

        timerProvider.setMotivitionSentencesEn(motivationSentencesEnList[
        timerProvider.setRandomNumber(motivationSentencesEnList.length)]);
        timerProvider.setMotivitionSentencesTur(motivationSentencesTurList[
        timerProvider.setRandomNumber(motivationSentencesTurList.length)]);
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
        //get Arrangment
        DocumentSnapshot<Map<String, dynamic>> scorsDoc =
        await firestore.collection('arrangement').doc('scors').get();
        Map<String, dynamic> scorsData = scorsDoc.data() ?? {};
        Arrangment arrangement1 = Arrangment.fromMap(scorsData['1']);
        Arrangment arrangement2 = Arrangment.fromMap(scorsData['2']);
        Arrangment arrangement3 = Arrangment.fromMap(scorsData['3']);
        Arrangment arrangement4 = Arrangment.fromMap(scorsData['4']);
        Arrangment arrangement5 = Arrangment.fromMap(scorsData['5']);
        Map<String, Arrangment> mapArrang = {
          '1': arrangement1,
          '2': arrangement2,
          '3': arrangement3,
          '4': arrangement4,
          '5': arrangement5,
        };
        await providerUser.setMapArrangment(mapArrang);

       if(context.mounted){
         await getLanguage(context);
       }
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
      tempString = List.from(tempString)
        ..removeAt(index);
      tempInt = List.from(tempInt)
        ..removeAt(index);
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
      print('ororororororororrrkasasfasfö');
      //set score
      double tempHours = timerProvider.getTempScore;
      await firestore
          .collection('users')
          .doc(providerUser.user.uid)
          .update({'score': tempHours});
      providerUser.setScore(tempHours);
      double tempTEventTime = timerProvider.getEventTime;

      // print('getEventTime $tempTEventTime');
      String eventTemp = providerUser.getEvent;
      //print('eventTemp : $eventTemp');
      Map<String, double> tempMapEvent = providerUser.getMapEvent;
      for (var entry in tempMapEvent.entries) {
        String key = entry.key;
        double value = entry.value;
        if (key == eventTemp) {
          tempTEventTime += value;
          String stringValue = tempTEventTime.toString();
          /*RegExp regex = RegExp(r'^\d*\.\d{0,3}');
          RegExpMatch? match = regex.firstMatch(stringValue);
          String result = match?.group(0) ?? stringValue;
          tempTEventTime = double.parse(result);*/
        }
      }
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

  Future<void> updateUserElements(BuildContext context, String bio, String name,
      bool lang) async {
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
          language: lang ? 'Tur' : 'En'
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
    Provider.of<ProviderUser>(context, listen: true);
    TimerProvider timerProvider =
    Provider.of<TimerProvider>(context, listen: true);
    try {
      Map<String, Arrangment> mapArrangment = providerUser.getMapArrangment;
      timerProvider.setTimerFinishControl(false);
      //double score = providerUser.getScore;
      print('fffffffffffffffffffffffffff');
      print('${providerUser.getScore} score');
      print('${timerProvider.getTempScore} getTempScore');
      Arrangment? arrangment1 = mapArrangment['1'];
      Arrangment? arrangment2 = mapArrangment['2'];
      Arrangment? arrangment3 = mapArrangment['3'];
      Arrangment? arrangment4 = mapArrangment['4'];
      Arrangment? arrangment5 = mapArrangment['5'];
      bool control =
      false; //fire base'e eklemesi için //eğer örnek olarak arrangment2ye ekledi ise tekrardan aynı değeri 3-4'e eklemesmesi için
      List<Arrangment> tempClassList = [
        arrangment1!,
        arrangment2!,
        arrangment3!,
        arrangment4!,
        arrangment5!
      ];
      List<Arrangment> tempClassList2 = [
      ];
      for (int i = 0; i < tempClassList.length; i++) {
        if (tempClassList[i].score < timerProvider.getTempScore) {
          control = true;
          Arrangment arrangment = Arrangment(
              imgUrl: providerUser.user.imageurl,
              uid: providerUser.user.uid,
              name: providerUser.user.name,
              email: providerUser.user.email,
              score: timerProvider.getTempScore);
          tempClassList2.add(arrangment);
          for (int j = 0; j < tempClassList.length; j++) {
            tempClassList2.add(tempClassList[j]);
          }
          break;
        }
      }
      tempClassList = tempClassList2;
      for (int i = 0; i < tempClassList.length; i++) {
        for (int j = i + 1; j < tempClassList.length; j++) {
          if (tempClassList[i].uid == tempClassList[j].uid) {
            tempClassList2.removeAt(j);
            //print(tempList[j].name + tempList[j].score.toString());
            break;
          }
        }
      }
      tempClassList = tempClassList2;
      for (int i = 0; i < tempClassList.length - 1; i++) {
        for (int j = 0; j < tempClassList.length - 1 - i; j++) {
          if (tempClassList[j].score < tempClassList[j + 1].score) {
            Arrangment temp = tempClassList[j];
            tempClassList[j] = tempClassList[j + 1];
            tempClassList[j + 1] = temp;
          }
        }
      }
      tempClassList2 = tempClassList;
      /*
      for(int i=0;i<tempClassList.length;i++){
        if(tempClassList[i].score < providerUser.user.score && providerUser.user.uid == tempClassList[i].uid){
          tempClassList2.removeAt(i);
          break;
        }
      }
      arrangment1=tempClassList2[0];
      arrangment2=tempClassList2[1];
      arrangment3=tempClassList2[2];
      arrangment4=tempClassList2[3];
      arrangment5=tempClassList2[4];*/
      /* if (arrangment1.score < timerProvider.getTempScore) {
        if (arrangment1.uid != providerUser.user.uid) {
          control = true;
          arrangment5 = arrangment4;
          arrangment4 = arrangment3;
          arrangment3 = arrangment2;
          arrangment2 = arrangment1;
          arrangment1 = Arrangment(
              imgUrl: providerUser.user.imageurl,
              uid: providerUser.user.uid,
              name: providerUser.user.name,
              email: providerUser.user.email,
              score: timerProvider.getTempScore);
        } else {
          control = true;
          arrangment1 = Arrangment(
              imgUrl: providerUser.user.imageurl,
              uid: providerUser.user.uid,
              name: providerUser.user.name,
              email: providerUser.user.email,
              score: timerProvider.getTempScore);
        }
      } else if (arrangment2!.score < timerProvider.getTempScore &&
          control == false) {
        if (providerUser.user.uid != arrangment1.uid &&
            providerUser.user.uid != arrangment2.uid) {
          control = true;

          arrangment5 = arrangment4;
          arrangment4 = arrangment3;
          arrangment3 = arrangment2;
          arrangment2 = Arrangment(
              imgUrl: providerUser.user.imageurl,
              uid: providerUser.user.uid,
              name: providerUser.user.name,
              email: providerUser.user.email,
              score: timerProvider.getTempScore);
        } else if (providerUser.user.uid == arrangment2.uid) {
          control = true;
          arrangment2 = Arrangment(
              imgUrl: providerUser.user.imageurl,
              uid: providerUser.user.uid,
              name: providerUser.user.name,
              email: providerUser.user.email,
              score: timerProvider.getTempScore);
        }
      } else if (arrangment3!.score < timerProvider.getTempScore &&
          control == false) {
        if (providerUser.user.uid != arrangment1.uid &&
            providerUser.user.uid != arrangment2.uid &&
            providerUser.user.uid != arrangment3.uid) {
          control = true;
          arrangment5 = arrangment4;
          arrangment4 = arrangment3;
          arrangment3 = Arrangment(
              imgUrl: providerUser.user.imageurl,
              uid: providerUser.user.uid,
              name: providerUser.user.name,
              email: providerUser.user.email,
              score: timerProvider.getTempScore);
        } else if (providerUser.user.uid == arrangment3.uid) {
          control = true;
          arrangment3 = Arrangment(
              imgUrl: providerUser.user.imageurl,
              uid: providerUser.user.uid,
              name: providerUser.user.name,
              email: providerUser.user.email,
              score: timerProvider.getTempScore);
        }
      } else if (arrangment4!.score < timerProvider.getTempScore &&
          control == false) {
        if (providerUser.user.uid != arrangment1.uid &&
            providerUser.user.uid != arrangment2.uid &&
            providerUser.user.uid != arrangment3.uid &&
            providerUser.user.uid != arrangment4.uid) {
          control = true;
          arrangment5 = arrangment4;
          arrangment4 = Arrangment(
              imgUrl: providerUser.user.imageurl,
              uid: providerUser.user.uid,
              name: providerUser.user.name,
              email: providerUser.user.email,
              score: timerProvider.getTempScore);
        } else if (providerUser.user.uid == arrangment4.uid) {
          control = true;
          arrangment4 = Arrangment(
              imgUrl: providerUser.user.imageurl,
              uid: providerUser.user.uid,
              name: providerUser.user.name,
              email: providerUser.user.email,
              score: timerProvider.getTempScore);
        }
      } else if (arrangment5!.score < timerProvider.getTempScore &&
          control == false) {
        control = true;
        if (providerUser.user.uid != arrangment1.uid &&
            providerUser.user.uid != arrangment2.uid &&
            providerUser.user.uid != arrangment3.uid &&
            providerUser.user.uid != arrangment4.uid) {
          arrangment5 = Arrangment(
              imgUrl: providerUser.user.imageurl,
              uid: providerUser.user.uid,
              name: providerUser.user.name,
              email: providerUser.user.email,
              score: timerProvider.getTempScore);
        }
      }*/
      if (control) {
        /*   List<Arrangment> tempList = [
          arrangment1,
          arrangment2!,
          arrangment3!,
          arrangment4!,
          arrangment5!
        ];*/
        /*List<Arrangment> uniqueObjects = tempList;
        for (int i = 0; i < tempList.length; i++) {
          for (int j = i + 1; j < tempList.length; j++) {
            if (tempList[i].uid == tempList[j].uid) {
              uniqueObjects.removeAt(j);
              //print(tempList[j].name + tempList[j].score.toString());
              break;
            }
          }
        }
        print('uzunluk : ${uniqueObjects.length}');
        int counter = 0;
        while (uniqueObjects.length < 5) {
          counter++;
          Arrangment arrangment = Arrangment(
              imgUrl: '',
              uid: 'test$counter',
              email: 'test_$counter@.com',
              name: 'test_$counter',
              score: 0.00 + counter);
          uniqueObjects.add(arrangment);
        }*/
        control = false;
        Map<String, Map<String, dynamic>> mapp = {
          '1': tempClassList2[0].toMap(),
          '2': tempClassList2[1].toMap(),
          '3': tempClassList2[2].toMap(),
          '4': tempClassList2[3].toMap(),
          '5': tempClassList2[4].toMap(),
        };
        mapArrangment = {
          '1': tempClassList2[0],
          '2': tempClassList2[1],
          '3': tempClassList2[2],
          '4': tempClassList2[3],
          '5': tempClassList2[4],
        };
        await firestore.collection('arrangement').doc('scors').update(mapp);
        providerUser.setMapArrangment(mapArrangment);
        timerProvider.setTimerFinishControl(false);
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
        "${_ddd(dateTime.hour)}:${_ddd(dateTime.minute)}:${_ddd(
        dateTime.second)}";
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
