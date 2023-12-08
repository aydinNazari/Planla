import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planla/controls/providersClass/provider_user.dart';
import 'package:planla/models/today_model.dart';
import 'package:planla/utiles/constr.dart';
import 'package:planla/widgets/addpage_card_widget.dart';
import 'package:provider/provider.dart';
import 'package:planla/models/user.dart' as model;

import '../controls/firebase/firestore._methods.dart';
import '../widgets/add_textfield_widget.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  late TodayModel todayModel;
  var selectedValue = '';
  List<TodayModel> todayList = [];

  // String value = '';

  String txt = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connectionKontrol(context);
    todayList.clear();
    getFirestore();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = Provider.of<ProviderUser>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        logOutFunc(context, size, false);
        return false;
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(left: size.width / 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height / 25,
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: size.width,
                      child: AddTextfieldWidget(onSubmit: (value) async {
                        txt = value;
                        value = '';
                        if (txt.isNotEmpty) {
                          DateTime dateTime = DateTime.now();
                          // DateTime'i Timestamp'e çevirir
                          Timestamp timestamp = Timestamp.fromDate(dateTime);
                          todayModel = TodayModel(
                              text: txt,
                              dateTime: timestamp,
                              done: false,
                              important: false,
                              typeWork: selectedValue,
                              email: user.user.email,
                              uid: user.user.uid);
                          bool res = await FirestoreMethods()
                              .firestoreUpload(context, user.user, todayModel);
                          if (res) {
                            updateFirestore(true, false, false, user.user, 0);
                            getFirestore();
                          }
                        } else {
                          showSnackBar(
                              context, 'Fill in all fields', Colors.red);
                        }
                      }),
                    ),
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: size.height / 30),
                        child: InkWell(
                          onTap: () async {},
                          child: Container(
                            width: size.width / 4,
                            height: size.height / 13,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(size.width / 50))),
                            child: Center(
                                child: Text(
                              'Add',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.width / 24),
                            )),
                          ),
                        ),
                      )
                    ],
                  ))
                ],
              ),
              //DropdownAddpageWidget(),
              //const AddPageCardWidget(),
              Expanded(
                child: ListView.builder(
                    itemCount: todayList.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: size.height / 50, right: size.width / 25),
                        child: InkWell(
                          onTap: (){
                            print('///----');
                            print(index);
                            print(todayList.length);
                          },
                          onLongPress: () async {
                            print('****************************');
                            print(todayList[index].text);
                            print(todayList.length);
                            print('****************************');
                            await FirestoreMethods()
                                .deletetodayTextitem(context, index, user);
                            todayList.removeAt(index);
                            print(todayList.length);
                            print(index);
                            print('////////////////////////////');
                            print(index);
                            setState(() {

                            });
                          },
                          child: AddPageCardWidget(
                            tikOntap: () {
                              if (todayList[index].done) {
                                updateFirestore(
                                    false, true, false, user.user, index);
                              } else {
                                updateFirestore(false, true, true, user.user, index);
                              }
                            },
                            doneControl: todayList[index].done,
                            todayModel: todayList[index],
                            importOntap: () async {
                              if (todayList[index].important) {
                                bool updateTodayTextImportantControl =
                                    await FirestoreMethods()
                                        .updateTodayTextImportant(
                                            context, false, user.user, index);
                              } else {
                                bool updateTodayTextImportantControl =
                                    await FirestoreMethods()
                                        .updateTodayTextImportant(
                                            context, true, user.user, index);
                              }
                            },
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getFirestore() async {
    bool res = await FirestoreMethods().getFiresoreData(context);
    if (res) {
      setState(() {
        todayList = Provider.of<ProviderUser>(context, listen: false).todayList;
      });
    }
  }

  Future<void> updateFirestore(bool taskProcess, bool doneProcess, bool value,
      model.User user, int index) async {
    bool updateUserControl = await FirestoreMethods()
        .updateUser(context, taskProcess, doneProcess, value);

    if (context.mounted) {
      bool updateTodayTextDoneControl = await FirestoreMethods()
          .updateTodayTextDone(context, value, user, index);
    }
  }
}
