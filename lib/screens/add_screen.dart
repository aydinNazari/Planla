import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:planla/controls/firebase/firestore._methods.dart';
import 'package:planla/controls/providersClass/provider_user.dart';
import 'package:planla/models/today_model.dart';
import 'package:planla/utiles/constr.dart';
import 'package:planla/widgets/textField/addpage_card_widget.dart';
import 'package:provider/provider.dart';
import '../controls/providersClass/timer_provider.dart';
import '../widgets/textField/add_textfield_widget.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  late TodayModel todayModel;
  var selectedValue = '';

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
    TimerProvider timerProvider =
        Provider.of<TimerProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        logOutFunc(context, size, false, user, timerProvider);
        return false;
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(left: size.width / 25),
          child: SingleChildScrollView(
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
                          child: AddTextfieldWidget(
                              hinttext: user.getLanguage ? 'Ekle...':'Add...',
                              onSubmit: (value) async {
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
                            } else {
                              showSnackBar(
                                  context,
                                  user.getLanguage
                                      ? 'Tüm alanları doldurun'
                                      : 'Fill in all fields',
                                  Colors.red);
                            }
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
                user.getTodayList.isEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: size.height / 4.5,
                          ),
                          SizedBox(
                            width: size.width,
                            height: size.height / 5,
                            child: Image.asset('assets/images/empty.png'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: size.height / 45),
                            child: Text( user.getLanguage ? 'Bugün için herhangi bir göreviniz yok':
                              'You don\'t have any task for today',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black26,
                                fontSize: size.width / 22,
                              ),
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
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
                                Navigator.of(context).pop();
                              }
                              setState(() {});
                            },
                            background: Container(
                              //color: Colors.black.withOpacity(0.3),
                              color: Colors.transparent,
                              child: Lottie.asset('assets/json/recycling.json'),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: size.height / 50,
                                  right: size.width / 25),
                              child: AddPageCardWidget(
                                //color: const Color(0xff540804),
                                //color: const Color(0xff1b3a4b),
                                color: const Color(0xff1d2d44),
                                //color: const Color(0xff415a77),
                                // color: const Color(0xff14213d),
                                cardList: user.getTodayList,
                                index: index,
                                tikOntap: () async {
                                  if (user.getTodayList[index].done) {
                                    await FirestoreMethods()
                                        .doneImportantUpdate(
                                            context,
                                            true,
                                            false,
                                            user.getTodayList[index].textUid);
                                  } else {
                                    await FirestoreMethods()
                                        .doneImportantUpdate(
                                            context,
                                            true,
                                            true,
                                            user.getTodayList[index].textUid);
                                  }
                                  setState(() {});
                                },
                                importOntap: () async {
                                  if (user.getTodayList[index].important) {
                                    await FirestoreMethods()
                                        .doneImportantUpdate(
                                            context,
                                            false,
                                            false,
                                            user.getTodayList[index].textUid);
                                  } else {
                                    await FirestoreMethods()
                                        .doneImportantUpdate(
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
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
