import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:planla/controls/providersClass/provider_user.dart';
import 'package:planla/controls/providersClass/timer_provider.dart';
import 'package:planla/utiles/colors.dart';
import 'package:planla/widgets/textinputfield_widget.dart';
import 'package:planla/widgets/timer_widget.dart';
import 'package:provider/provider.dart';
import '../controls/firebase/firestore._methods.dart';
import '../widgets/button_loginsignin_widget.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Timer? timer;
  int hoursNumeric = 0;
  int minuteNumeric = 0;
  int secendNumeric = 0;
  String _event = '';
  List<bool> checkboxList = [];

  @override
  void initState() {
    TimerProvider timerProvider =
        Provider.of<TimerProvider>(context, listen: false);

    timerProvider.reset();
    checkboxListUpdate(false);
    super.initState();
  }

  void checkboxListUpdate(bool control){
    ProviderUser providerUser =
    Provider.of<ProviderUser>(context, listen: false);
    checkboxList.clear();
    for (int i = 0; i < providerUser.getEventsString.length; i++) {
      checkboxList.add(false);
    }
    providerUser.setCheckBoxList(checkboxList,control);
  }

  void checkBoxSetValue(int index,BuildContext context) {
    ProviderUser providerUser =
        Provider.of<ProviderUser>(context, listen: false);
    checkboxList = providerUser.getCheckBoxList;
    for (int i = 0; i < providerUser.getEventsString.length; i++) {
      if (i == index) {
        checkboxList[i] = true;
      } else {
        checkboxList[i] = false;
      }
    }
    providerUser.setCheckBoxList(checkboxList,true);
  }

  @override
  Widget build(BuildContext context) {
    TimerProvider providerTimer =
        Provider.of<TimerProvider>(context, listen: false);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: size.height / 80,
        ),
        child: GestureDetector(
          onTap: () {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Spacer(),
                          Text(
                            'Add',
                            style: TextStyle(
                                color: primeryColor,
                                fontSize: size.width / 20,
                                fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: size.height / 45, bottom: size.height / 80),
                        child: Text(
                          'Add your new event',
                          style: TextStyle(
                              color: const Color(0xff26303b),
                              fontWeight: FontWeight.w400,
                              fontSize: size.width / 20),
                        ),
                      ),
                      SizedBox(
                        width: size.width / 2,
                        height: size.height / 12,
                        child: TextInputField(
                            inputLenghtControl: true,
                            hintText: 'Add new activity',
                            labelTextWidget: const Text('up to 10 characters'),
                            iconWidget: const SizedBox(),
                            obscrueText: false,
                            onchange: (v) {
                              _event = v;
                            },
                            hintColor: Colors.grey),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: size.height / 25),
                        child: Row(
                          children: [
                            const Spacer(),
                            TextButton(
                              onPressed: () async {
                                Map<String, dynamic> event = {_event: 0};
                               await FirestoreMethods().saveEvent(context, event);
                                checkboxListUpdate(true);
                                if(context.mounted){
                                  Navigator.of(context).pop();
                                }
                              },
                              child: const Text('Yes'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('No'),
                            ),
                            const Spacer()
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
          child: Container(
            width: size.width / 8,
            height: size.height / 15,
            decoration:
                BoxDecoration(color: primeryColor, shape: BoxShape.circle),
            child: Center(
              child: Text(
                '+',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: size.width / 15,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      body: providerTimer.timerScreenType
          ? buildTimerSetScreen()
          : buildTimerCountScreen(),
    );
  }

  Widget buildTimerCountScreen() {
    TimerProvider timerProvider =
        Provider.of<TimerProvider>(context, listen: true);

    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: size.height / 25),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: size.width,
              child: Row(
                children: [
                  const Spacer(),
                  TimerWidget(
                      /*hours: timerProvider.getRemainingHours(),
                    minutes: timerProvider.getRemainingMinutes(),
                    //secends: timerProvider.getRemainingSeconds(),*/
                      hours: timerProvider.getdenemeHours,
                      minutes: timerProvider.getdenemeMinute,
                      secends: timerProvider.getdenemeSecend),
                  const Spacer(),
                ],
              ),
            ),
            SizedBox(
              height: size.height / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: size.height / 50),
                    child: SizedBox(
                      width: size.width,
                      height: size.height / 3.2,
                      child: Lottie.network(
                        timerProvider.getMotivationLttieUrl,
                      ),
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(
                        left: size.width / 10,
                        right: size.width / 10,
                        top: size.height / 80),
                    child: Text(
                      timerProvider.getMotivationSentences,
                      softWrap: true,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: size.width / 22,
                        wordSpacing: 0,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  )),
                ],
              ),
            ),
            buildButton(),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView buildTimerSetScreen() {
    TimerProvider timerProvider =
        Provider.of<TimerProvider>(context, listen: true);
    ProviderUser providerUser =
        Provider.of<ProviderUser>(context, listen: true);
    checkboxList = providerUser.getCheckBoxList;
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: size.height / 20,
          ),
          /*   SizedBox(
              width: size.width,
              height:100,
              child: Row(
                children: [
                  const Spacer(),
                  TimerWidget(
                    hours: hoursNumeric < 10
                        ? '0$hoursNumeric'
                        : hoursNumeric.toString(),
                    minutes: minuteNumeric < 10
                        ? '0$minuteNumeric'
                        : minuteNumeric.toString(),
                    secends: secendNumeric < 10
                        ? '0$secendNumeric'
                        : secendNumeric.toString(),
                  ),
                  const Spacer(),
                ],
              )),*/
          Padding(
            padding: EdgeInsets.only(
                //        top: size.height / 25,
                left: size.width / 25,
                right: size.width / 25),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  children: [
                    buildNumericText(size, 'Hours'),
                    numeric(
                      current: hoursNumeric,
                      onChanged: (value) {
                        setState(() {
                          hoursNumeric = value;
                        });
                        timerProvider.reset();
                      },
                    ),
                  ],
                )),
                Expanded(
                    child: Column(
                  children: [
                    numeric(
                      current: minuteNumeric,
                      onChanged: (value) {
                        setState(() {
                          minuteNumeric = value;
                        });
                        timerProvider.reset();
                      },
                    ),
                    buildNumericText(size, 'Minute'),
                  ],
                )),
                Expanded(
                    child: Column(
                  children: [
                    buildNumericText(size, 'Secend'),
                    numeric(
                      current: secendNumeric,
                      onChanged: (value) {
                        setState(() {
                          secendNumeric = value;
                        });
                        timerProvider.reset();
                      },
                    ),
                  ],
                )),
              ],
            ),
          ),
          /* Padding(
            padding:
                EdgeInsets.only(left: size.height / 25, top: size.height / 25),
            child: SizedBox(
              width: size.width / 2,
              height: size.height / 5,
              child: AddTextfieldWidget(onSubmit: (v) {}),
            ),
          ),*/
          Padding(
            padding: EdgeInsets.only(top: size.height / 25),
            child: SizedBox(
              height: size.height / 2.6,
              width: size.width,
              child: providerUser.getEventsString.isEmpty
                  ? Column(
                      children: [
                        SizedBox(
                          width: size.width,
                          height: size.height / 3.5,
                          child: Lottie.network(
                              'https://lottie.host/62c43383-e871-430e-8e0b-6dde45b772fa/Xdx9EidvGt.json'),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: size.width / 6),
                          child: Text(
                            'You don\'t have any events, you must add at least one event first ',
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: TextStyle(
                                color: Colors.grey, fontSize: size.width / 25),
                          ),
                        )
                      ],
                    )
                  : Padding(
                    padding: EdgeInsets.only(left: size.width/15),
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: size.width / 2,
                          childAspectRatio: size.height / 200,
                          crossAxisSpacing: size.height / 20,
                          mainAxisSpacing: size.width / 25,
                        ),
                        itemCount: providerUser.getEventsString.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (_, index) {
                          return SizedBox(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Checkbox(
                                    value: providerUser.getCheckBoxList[index],
                                    onChanged: (value) {
                                      checkBoxSetValue(index,context);
                                    },
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: GestureDetector(
                                    onTap: (){
                                      checkBoxSetValue(index,context);
                                    },
                                    child: Text(
                                      providerUser.getEventsString[index],
                                      softWrap: true,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: const Color(0xff193242),
                                        fontSize: size.width / 30,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(),
              SizedBox(
                width: size.width / 3,
                height: size.height / 12,
                child: InkWell(
                  onTap: () {
                    if(providerUser.getEventsString.isNotEmpty){
                      timerProvider.setHours(hoursNumeric);
                      timerProvider.setMinute(minuteNumeric);
                      timerProvider.setSecends(secendNumeric);
                      timerProvider.startTime(resets: false);
                      timerProvider.setTimerScreenType(false);
                      // BackgroundService().initSercice(context);
                      timerProvider.reset();
                      //BackgroundService().initSercice(hoursNumeric,minuteNumeric,secendNumeric);
                    }
                  },
                  child: LoginSigninButtonWidget(
                    radiusControl: true,
                    color: providerUser.getEventsString.isNotEmpty ? primeryColor : Colors.grey,
                    txt: 'Go',
                  ),
                ),
              ),
              /*  Padding(
                padding: EdgeInsets.only(right: size.width / 40),
                child: Container(
                  //margin: EdgeInsets.only(bottom: size.height/12),
                  width: size.width / 8,
                  height: size.height / 12,
                  decoration: BoxDecoration(
                      color: primeryColor, shape: BoxShape.circle),
                  child: Center(
                    child: Text(
                      '+',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: size.width / 15,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),*/
              const Spacer(),
            ],
          )
        ],
      ),
    );
  }

  Widget buildNumericText(Size size, String txt) {
    return Padding(
      padding: EdgeInsets.only(top: size.height / 80, bottom: size.height / 80),
      child: Text(
        txt,
        style: TextStyle(
            color: Colors.grey,
            fontSize: size.width / 20,
            fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget buildButton() {
    TimerProvider timerProvider =
        Provider.of<TimerProvider>(context, listen: true);
    bool type =
        timerProvider.timer == null ? false : timerProvider.timer!.isActive;
    Size size = MediaQuery.of(context).size;
    // final isComplated = duration.inSeconds == 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width / 25),
          child: InkWell(
            onTap: () {
              if (type) {
                timerProvider.stop(resets: false);
              } else {
                timerProvider.startTime(resets: false);
              }
            },
            child: SizedBox(
              width: size.width / 3,
              height: size.height / 13,
              child: LoginSigninButtonWidget(
                radiusControl: true,
                color:
                    timerProvider.getCounter != 0 ? Colors.black : Colors.grey,
                txt: type ? 'Stop' : 'Resume',
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: size.width / 25),
          child: GestureDetector(
            onTap: () {
              setState(() {
                timerProvider.stop(resets: true);
                timerProvider.setTimerScreenType(true);
                timerProvider.setTimerReset('00');
              });
            },
            child: SizedBox(
              width: size.width / 3,
              height: size.height / 13,
              child: const LoginSigninButtonWidget(
                radiusControl: true,
                color: Colors.black,
                txt: 'Reset',
              ),
            ),
          ),
        ),
        //   Spacer(),
      ],
    );
  }

  Widget numeric({required int current, required ValueChanged<int> onChanged}) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff2a2a2a),
        borderRadius: BorderRadius.all(Radius.circular(size.width / 25)),
      ),
      child: Column(
        children: <Widget>[
          NumberPicker(
            value: current,
            minValue: 0,
            maxValue: 59,
            selectedTextStyle:
                TextStyle(color: Colors.white, fontSize: size.width / 20),
            textStyle: const TextStyle(color: Colors.white70),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
