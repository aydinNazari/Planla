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
  }

  bool typeScreen = true;

  // typeScree == true -> taskScreen
  // typeScree == false -> DoneScreen

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<ProviderUser>(context, listen: false);
    Size size = MediaQuery.of(context).size;
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
                          '@${(user.user.email).substring(0, (user.user.email).indexOf('@'))}',
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
                      count: (user.user.taskCount).toString(),
                    ),
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
                  child: cards(user, size)),
            )
          ],
        ),
      ),
    );
  }

  ListView cards(ProviderUser user, Size size) {
    return ListView.builder(
      itemCount: typeScreen ? user.getTankList.length : user.getDoneList.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(top: size.height / 50),
          child: AddPageCardWidget(
            cardList: typeScreen ? user.getTankList : user.getDoneList,
            index: index,
            tikOntap: () async {
              if (typeScreen
                  ? user.getTankList[index].done
                  : user.getDoneList[index].done) {
                if (typeScreen
                    ? user.getTankList[index].done
                    : user.getDoneList[index].done) {
                  if (typeScreen) {
                    await FirestoreMethods().doneImportantUpdate(
                        context, true, false, user.getTankList[index].textUid);
                    if (context.mounted) {
                      await FirestoreMethods()
                          .userDoneImpotantUpdate(context, true, false);
                    }
                  } else {
                    await FirestoreMethods().doneImportantUpdate(
                        context, true, true, user.getDoneList[index].textUid);
                    if (context.mounted) {
                      await FirestoreMethods()
                          .userDoneImpotantUpdate(context, true, true);
                    }
                  }
                }
                setState(() {});
              } else {

              }
              setState(() {});
            },
            importOntap: () async {
              if (typeScreen
                  ? user.getTankList[index].important
                  : user.getDoneList[index].important) {
              } else {}
              setState(() {});
            },
          ),
        );
      },
    );
  }
}
