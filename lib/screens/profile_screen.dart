import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:planla/controls/providersClass/provider_user.dart';
import 'package:planla/screens/navigator_screen.dart';
import 'package:planla/screens/setting_screen.dart';
import 'package:planla/utiles/colors.dart';
import 'package:provider/provider.dart';

import '../controls/firebase/firestore._methods.dart';
import '../controls/providersClass/timer_provider.dart';
import '../utiles/constr.dart';
import '../widgets/textField/addpage_card_widget.dart';
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
    final providerUSer = Provider.of<ProviderUser>(context, listen: true);
    TimerProvider timerProvider =
        Provider.of<TimerProvider>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (widget.control == false) {
          logOutFunc(context, size, false, providerUSer, timerProvider);
          return false;
        } else {
          Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: const NavigatorScreen(),
              ));
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            widget.control //for back button
                ? Padding(
                    padding: EdgeInsets.only(left: size.width / 25),
                    child: InkWell(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: const NavigatorScreen()),
                            (route) => route.isCurrent,
                          );
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
                  right: size.width / 25, top: size.height / 80),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.topToBottom,
                          child: const SettingScreen()));
                },
                child: Icon(
                  Icons.settings,
                  size: size.width / 18,
                  color: primeryColor,
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
                          providerUSer.user.name,
                          style: TextStyle(
                              color: textColor,
                              fontSize: size.width / 14,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '@${(providerUSer.user.email).substring(0, (providerUSer.user.email).indexOf('@'))}',
                          style: TextStyle(
                              color: Colors.black38,
                              fontSize: size.width / 23,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          providerUSer.user.bio,
                          style: TextStyle(
                              color: primeryColor,
                              fontSize: size.width / 22,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: size.width / 10),
                  child: SizedBox(
                      width: size.width / 3.5,
                      height: size.width / 3.5,
                      child: GestureDetector(
                          onTap: () {
                            uploadOrRemoveProfilePhoto(
                                context, size, true, providerUSer);
                          },
                          child: ProgileImgWidget(
                              url: providerUSer.user.imageurl))),
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
                      txt: providerUSer.getLanguage ? 'Görev' : 'Task',
                      count: (providerUSer.getTankList.length).toString(),
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
                        txt: providerUSer.getLanguage ? 'Tamamlanan ' : 'Done',
                        count: (providerUSer.getDoneList.length).toString()),
                  ),
                  const Spacer(),
                  TasksCountWidget(
                      size: size,
                      txt: providerUSer.getLanguage ? 'Rekor' : 'Record',
                      count: providerUSer.getLanguage ? '${providerUSer.getTankList.length} adet'
                      :'${providerUSer.getTankList.length} items'),
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
                  child: cards(providerUSer, size)),
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
            color: primeryColor,
            cardList: typeScreen ? user.getTankList : user.getDoneList,
            index: index,
            tikOntap: () async {
              if (typeScreen) {
                if (user.getTankList[index].done) {
                  await FirestoreMethods().doneImportantUpdate(
                      context, true, false, user.getTankList[index].textUid);
                } else {
                  await FirestoreMethods().doneImportantUpdate(
                      context, true, true, user.getTankList[index].textUid);
                }
              } else {
                if (user.getDoneList[index].done) {
                  await FirestoreMethods().doneImportantUpdate(
                      context, true, false, user.getDoneList[index].textUid);
                } else {
                  await FirestoreMethods().doneImportantUpdate(
                      context, true, true, user.getDoneList[index].textUid);
                }
              }
              setState(() {});
            },
            importOntap: () async {
              if (typeScreen) {
                if (user.getTankList[index].important) {
                  await FirestoreMethods().doneImportantUpdate(
                      context, false, false, user.getTankList[index].textUid);
                } else {
                  await FirestoreMethods().doneImportantUpdate(
                      context, false, true, user.getTankList[index].textUid);
                }
              } else {
                if (user.getDoneList[index].important) {
                  await FirestoreMethods().doneImportantUpdate(
                      context, false, false, user.getDoneList[index].textUid);
                } else {
                  await FirestoreMethods().doneImportantUpdate(
                      context, false, true, user.getDoneList[index].textUid);
                }
              }
              setState(() {});
            },
          ),
        );
      },
    );
  }
}
