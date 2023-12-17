import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:planla/controls/firebase/firestore._methods.dart';
import 'package:planla/controls/providersClass/provider_user.dart';
import 'package:planla/models/today_model.dart';
import 'package:planla/utiles/constr.dart';
import 'package:planla/widgets/addpage_card_widget.dart';
import 'package:provider/provider.dart';
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
                          if (txt.isNotEmpty) {
                            todayModel = TodayModel(
                                text: txt,
                                dateTime: FirestoreMethods().getTimeStamp(),
                                done: false,
                                important: false,
                                typeWork: selectedValue,
                                email: user.user.email,
                                textUid: '',
                                firestorId: '');
                            await FirestoreMethods()
                                .textSave(context, todayModel);
                            if(context.mounted){
                              await FirestoreMethods().userDoneImpotantUpdate(context,false,true);
                            }
                            setState(() {});
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
                  itemCount: user.getTodayList.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: ValueKey<TodayModel>(user.getTodayList[index]),
                      onDismissed: (DismissDirection direction) async {
                        lottieProgressDialog(
                            context, 'assets/json/deleting.json');
                        await FirestoreMethods().deleteCard(
                            context, user.getTodayList[index].textUid);
                        if (context.mounted) {
                          await FirestoreMethods().userDoneImpotantUpdate(context,false,false);
                        }
                        if(context.mounted){
                          Navigator.of(context).pop();
                        }
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
                          cardList: user.getTodayList,
                          index: index,
                          tikOntap: () async {
                            if (user.getTodayList[index].done) {
                              await FirestoreMethods().doneImportantUpdate(
                                  context,
                                  true,
                                  false,
                                  user.getTodayList[index].textUid);
                              if(context.mounted){
                                await FirestoreMethods().userDoneImpotantUpdate(context,true,false);
                              }

                            } else {
                              await FirestoreMethods().doneImportantUpdate(
                                  context,
                                  true,
                                  true,
                                  user.getTodayList[index].textUid);
                              if(context.mounted){
                                await FirestoreMethods().userDoneImpotantUpdate(context,true,true);
                              }
                            }
                            setState(() {});
                          },
                          importOntap: () async {
                            if (user.getTodayList[index].important) {
                              await FirestoreMethods().doneImportantUpdate(
                                  context,
                                  false,
                                  false,
                                  user.getTodayList[index].textUid);

                            } else {
                              await FirestoreMethods().doneImportantUpdate(
                                  context,
                                  false,
                                  true,
                                  user.getTodayList[index].textUid);
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
}
