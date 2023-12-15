import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:planla/controls/firebase/firestore._methods.dart';
import 'package:planla/controls/providersClass/provider_user.dart';
import 'package:planla/models/today_model.dart';
import 'package:planla/utiles/constr.dart';
import 'package:planla/widgets/addpage_card_widget.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../widgets/add_textfield_widget.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  late TodayModel todayModel;
  var selectedValue = '';
/*  List<TodayModel> todayList = [];*/

  String txt = '';

  @override
  void initState() {
    super.initState();
    connectionKontrol(context);
    getData();
  }
  getData() async {
    await FirestoreMethods().getData(context);
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
                          DateTime dateTime = DateTime.now();
                          // DateTime'i Timestamp'e çevirir
                          Timestamp timestamp = Timestamp.fromDate(dateTime);
                          if (txt.isNotEmpty) {
                            todayModel = TodayModel(
                                text: txt,
                                dateTime:  timestamp,
                                done: false,
                                important: false,
                                typeWork: selectedValue,
                                email: user.user.email,
                                textUid: '',
                                firestorId: '');
                            await FirestoreMethods().textSave(context, todayModel);
                          } else {
                            showSnackBar(
                                context, 'Fill in all fields', Colors.red);
                          }
                        }),
                      ),
                    ),
                  ),
                ],
              ),
              //DropdownAddpageWidget(),
              //const AddPageCardWidget(),
              Expanded(
                child: ListView.builder(
                  itemCount: user.getTankList.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: ValueKey<TodayModel>(user.getTankList[index]),
                      onDismissed: (DismissDirection direction) async {
                     /*   await FirestoreMethods().deletetodayTextitem(   buuuuuuu
                            context, user, todayList[index]);*/

                        /*  if(context.mounted){
                          await FirestoreMethods().updateTank(context, user,
                              todayList[index], false, todayList[index].textUid);
                        }*/

                        setState(() {
                          if (user.getTankList[index].done) {
                          /*  FirestoreMethods()
                                .updateTaskDoneCount(context, false, true, false);*/
                          }
                        /*  FirestoreMethods()
                              .updateTaskDoneCount(context, true, false, false);*/

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
                            if (user.getTankList[index].done) {
                              /*updateFirestore(
                                  false, true, false, user, todayList[index]);*/
                              user.getTodayList[index].done = false;
                            /*  FirestoreMethods()
                                  .updateTaskDoneCount(context, false, true, false);*/
                            } else {
                              /*updateFirestore(
                                  false, true, true, user, todayList[index]);*/
                              user.getTodayList[index].done = true;
                             /* FirestoreMethods()
                                  .updateTaskDoneCount(context, false, true, true);*/
                            }
                            setState(() {});
                          },
                          importOntap: () async {
                            if (user.getTankList[index].important) {
                              /*updateFirestore(
                                  true, false, false, user, todayList[index]);*/

                              user.getTodayList[index].important = false;
                            } else {
                              /*updateFirestore(
                                  true, false, true, user, todayList[index]);*/
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

/*  Future<void> getFirestore() async {
   // bool res = await FirestoreMethods().getFiresoreData(context);
*//*    if (res) {
      setState(() {
        todayList =
            Provider.of<ProviderUser>(context, listen: false).getTodayList;
      });
    }*//*
  }*/

/*  Future<void> updateFirestore(bool importantProcess, bool doneProcess,
      bool value, ProviderUser user, TodayModel todayModel) async {
    *//* bool updateUserControl = await FirestoreMethods()
        .updateUser(context, taskProcess, doneProcess, value);*//*
    if (doneProcess) {
      *//*await FirestoreMethods()
          .updateTodayTextDone(context, value, user, todayModel);*//*
    }
    if (importantProcess) {
      if (context.mounted) {
     *//*   await FirestoreMethods()
            .updateTodayTextImportant(context, value, user, todayModel);*//*
      }
    }
  }*/
}
