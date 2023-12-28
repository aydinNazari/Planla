import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:planla/controls/providersClass/provider_user.dart';
import 'package:planla/controls/providersClass/timer_provider.dart';
import 'package:planla/utiles/colors.dart';
import 'package:planla/utiles/constr.dart';
import 'package:planla/widgets/add_textfield_widget.dart';
import 'package:planla/widgets/timer_widget.dart';
import 'package:provider/provider.dart';
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

  @override
  void initState() {
    TimerProvider timerProvider= Provider.of<TimerProvider>(context, listen: false);
    timerProvider.reset();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TimerProvider providerTimer =
        Provider.of<TimerProvider>(context, listen: false);
    return Scaffold(
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
                        left: size.width / 10, right: size.width / 10,top: size.height/80),
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
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: size.height / 20,
          ),
          SizedBox(
              width: size.width,
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
              )),
          Padding(
            padding: EdgeInsets.only(
                top: size.height / 25,
                left: size.width / 25,
                right: size.width / 25),
            child: Row(
              children: [
                Expanded(
                    child: numeric(
                  current: hoursNumeric,
                  onChanged: (value) {
                    setState(() {
                      hoursNumeric = value;
                    });
                    timerProvider.reset();
                  },
                )),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width / 80),
                  child: numeric(
                    current: minuteNumeric,
                    onChanged: (value) {
                      setState(() {
                        minuteNumeric = value;
                      });
                      timerProvider.reset();
                    },
                  ),
                )),
                Expanded(
                    child: numeric(
                  current: secendNumeric,
                  onChanged: (value) {
                    setState(() {
                      secendNumeric = value;
                    });
                    timerProvider.reset();
                  },
                )),
              ],
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(left: size.height / 25, top: size.height / 25),
            child: SizedBox(
              width: size.width / 2,
              height: size.height / 5,
              child: AddTextfieldWidget(onSubmit: (v) {}),
            ),
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
                      timerProvider.setHours(hoursNumeric);
                      timerProvider.setMinute(minuteNumeric);
                      timerProvider.setSecends(secendNumeric);
                      timerProvider.startTime(resets: false);
                      timerProvider.setTimerScreenType(false);
                      // BackgroundService().initSercice(context);
                      timerProvider.reset();
                      //BackgroundService().initSercice(hoursNumeric,minuteNumeric,secendNumeric);
                    },
                    child: LoginSigninButtonWidget(
                        radiusControl: true, color: primeryColor, txt: 'Go')),
                const Spacer()
              ],
            ),
          )
        ],
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
