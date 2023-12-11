import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:planla/controls/providersClass/provider_user.dart';
import 'package:planla/models/today_model.dart';
import 'package:planla/utiles/constr.dart';
import 'package:planla/widgets/addpage_card_widget.dart';
import 'package:provider/provider.dart';
import 'package:planla/models/user.dart' as model;
import 'package:uuid/uuid.dart';

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
                    child: Padding(
                      padding: EdgeInsets.only(right: size.width / 25),
                      child: SizedBox(
                        width: size.width,
                        child: AddTextfieldWidget(onSubmit: (value) async {
                          txt = value;
                          value = '';
                          var uuid = const Uuid();
                          var id = uuid.v4();
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
                                textUid: id,
                                firestorId: '');
                            bool res = await FirestoreMethods()
                                .firestoreUpload(context, user, todayModel, id);
                            if (res) {
                              updateFirestore(
                                  true, false, false, user, todayModel);
                              getFirestore();
                            }
                          } else {
                            showSnackBar(
                                context, 'Fill in all fields', Colors.red);
                          }
                        }),
                      ),
                    ),
                  ),
                  /*Expanded(
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
                  ))*/
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
                    return Dismissible(
                      key: ValueKey<TodayModel>(todayList[index]),
                      onDismissed: (DismissDirection direction) async {
                        await FirestoreMethods().deletetodayTextitem(
                            context, user, todayList[index]);
                        /*  if(context.mounted){
                          await FirestoreMethods().updateTank(context, user,
                              todayList[index], false, todayList[index].textUid);
                        }*/
                        setState(() {
                          todayList = user.getTodayList;
                        });
                      },
                      background: Container(
                        //color: Colors.black.withOpacity(0.3),
                        color: Colors.transparent,
                        child: Lottie.asset('assets/json/recycling.json'),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: size.height / 50, right: size.width / 25),
                        child: AddPageCardWidget(
                          index: index,
                          tikOntap: () {
                            if (todayList[index].done) {
                              updateFirestore(
                                  false, true, false, user, todayList[index]);
                              user.getTodayList[index].done = false;
                            } else {
                              updateFirestore(false, true, true, user, todayList[index]);
                              user.getTodayList[index].done = true;
                            }
                            setState(() {});
                          },
                          importOntap: () async {
                            if (todayList[index].important) {
                              await FirestoreMethods().updateTodayTextImportant(
                                  context, false, user,todayList[index]);
                              user.getTodayList[index].important = false;
                            } else {
                              await FirestoreMethods().updateTodayTextImportant(
                                  context, true, user,todayList[index]);
                              user.getTodayList[index].important = true;
                            }
                            setState(() {});
                          },
                        ),
                      ),
                    );
                  },
                ),
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
        todayList =
            Provider.of<ProviderUser>(context, listen: false).getTodayList;
      });
    }
  }

  Future<void> updateFirestore(bool taskProcess, bool doneProcess, bool value,
      ProviderUser user, TodayModel todayModel) async {
    bool updateUserControl = await FirestoreMethods()
        .updateUser(context, taskProcess, doneProcess, value);

    if (context.mounted) {
      await FirestoreMethods()
          .updateTodayTextDone(context, value, user, todayModel);
    }
  }
}
