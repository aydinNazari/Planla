import 'dart:async';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:planla/controls/providersClass/timer_provider.dart';
import 'package:planla/utiles/colors.dart';
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
    Provider.of<TimerProvider>(context, listen: false).reset();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TimerProvider providerTimer=Provider.of<TimerProvider>(context, listen: false);
    return Scaffold(
      body: providerTimer.timerType ? buildTimerSetScreen() : buildTimerCountScreen(),
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
                    hours: timerProvider.getRemainingHours(),
                    minutes: timerProvider.getRemainingMinutes(),
                    secends: timerProvider.getRemainingSeconds(),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            SizedBox(
              height: size.height / 2,
              child: const Center(
                  child: Text('motivation cümleleri ve görselleri ')),
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
                      setState(() {

                        timerProvider.setHours(hoursNumeric);
                        timerProvider.setMinute(minuteNumeric);
                        timerProvider.setSecends(secendNumeric);
                        timerProvider.startTime(resets: false);
                        timerProvider.setTimerScreenType(false);
                        timerProvider.reset();
                        //BackgroundService().initSercice(hoursNumeric,minuteNumeric,secendNumeric);
                      });
                    },
                    child: LoginSigninButtonWidget(
                        color: primeryColor, txt: 'Go')),
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
    bool type = timerProvider.timer == null ? false : timerProvider.timer!.isActive;
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
                  color: Colors.black, txt: type ? 'Stop' : 'Resume'),
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
              });
            },
            child: SizedBox(
              width: size.width / 3,
              child: const LoginSigninButtonWidget(
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
