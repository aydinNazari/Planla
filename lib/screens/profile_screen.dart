import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:planla/controls/providersClass/provider_user.dart';
import 'package:planla/utiles/colors.dart';
import 'package:provider/provider.dart';

import '../controls/firebase/firestore._methods.dart';
import '../models/today_model.dart';
import '../utiles/constr.dart';
import '../widgets/addpage_card_widget.dart';
import '../widgets/profile_img_widget.dart';
import '../widgets/task_done_widget.dart';

class ProfileScreen extends StatefulWidget {
  final bool control;

  //control ==true back arrow icon=true : back arrow icon=false
  const ProfileScreen({Key? key, required this.control}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connectionKontrol(context);
    todayList1.clear();
  }

  List<TodayModel> getFirestore(){
    /*  setState(() {
        todayList1 =
            FirestoreMethods().profileScreenGetTodayList(context);
      });*/
      return todayList1;
   // }
  }

  String userName = '';
  bool typeScreen = true;
  List<TodayModel> todayList1 = [];
  List<TodayModel> todayList2 = [];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<ProviderUser>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    userName = (user.user.email).substring(0, (user.user.email).indexOf('@'));
    return WillPopScope(
      onWillPop: () async {
        logOutFunc(context, size, false);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            widget.control //for back button
                ? Padding(
                    padding: EdgeInsets.only(left: size.width / 25),
                    child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: size.width / 16,
                        )),
                  )
                : const SizedBox(),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(
                right: size.width / 25,
              ),
              child: InkWell(
                onTap: () {
                  logOutFunc(context, size, true);
                },
                child: Icon(
                  Icons.logout,
                  size: size.width / 18,
                  color: Colors.black,
                ),
              ),
            ),
          ],
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: EdgeInsets.only(left: size.width / 10),
                    child: Column(
                      children: [
                        Text(
                          user.user.name,
                          style: TextStyle(
                              color: textColor,
                              fontSize: size.width / 14,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '@$userName',
                          style: TextStyle(
                              color: Colors.black38,
                              fontSize: size.width / 23,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: size.width / 10),
                  child: const ProgileImgWidget(type: 2),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                top: size.height / 25,
              ),
              child: Row(
                children: [
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      setState(() {
                        typeScreen = true;
                      });
                    },
                    child: TasksCountWidget(
                        size: size,
                        txt: 'Task',
                        count: (user.user.taskCount).toString()),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      setState(() {
                        typeScreen = false;
                      });
                    },
                    child: TasksCountWidget(
                        size: size,
                        txt: 'Done',
                        count: (user.user.doneCount).toString()),
                  ),
                  const Spacer(),
                  TasksCountWidget(size: size, txt: 'Plaka', count: '***'),
                  const Spacer()
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  right: size.width / 50,
                  left: size.width / 50,
                  top: size.height / 80),
              child: Container(
                width: size.width,
                height: size.height / 130,
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.all(
                      Radius.circular(size.width / 25),
                    )),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: size.width / 50, right: size.width / 50),
                child: typeScreen
                    ? cards(user, size, getFirestore())
                    : cards(user, size, todayList2),
              ),
            )
          ],
        ),
      ),
    );
  }

  ListView cards(ProviderUser user, Size size, List<TodayModel> todayList) {
    return ListView.builder(
      itemCount: todayList.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(top: size.height / 50),
          child: AddPageCardWidget(
            index: index,
            tikOntap: () {
              if (todayList[index].done) {
                updateFirestore(false, true, false, user, todayList[index]);
                user.getTodayList[index].done = false;
               /* FirestoreMethods()
                    .updateTaskDoneCount(context, false, true, false);*/
              } else {
                updateFirestore(false, true, true, user, todayList[index]);
                user.getTodayList[index].done = true;
               /* FirestoreMethods()
                    .updateTaskDoneCount(context, false, true, true);*/
              }
              setState(() {});
            },
            importOntap: () async {
              if (todayList[index].important) {
                updateFirestore(true, false, false, user, todayList[index]);

                user.getTodayList[index].important = false;
              } else {
                updateFirestore(true, false, true, user, todayList[index]);
                user.getTodayList[index].important = true;
              }
              setState(() {});
            },
          ),
        );
      },
    );
  }

  Future<void> updateFirestore(bool importantProcess, bool doneProcess,
      bool value, ProviderUser user, TodayModel todayModel) async {
    /* bool updateUserControl = await FirestoreMethods()
        .updateUser(context, taskProcess, doneProcess, value);*/
    if (doneProcess) {
   /*   await FirestoreMethods()
          .updateTodayTextDone(context, value, user, todayModel);*/
    }
    if (importantProcess) {
      if (context.mounted) {
       /* await FirestoreMethods()
            .updateTodayTextImportant(context, value, user, todayModel);*/
      }
    }
  }
}
