import 'dart:async';

import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:planla/utiles/colors.dart';
import 'package:planla/widgets/add_textfield_widget.dart';
import 'package:planla/widgets/timer_widget.dart';

import '../widgets/button_loginsignin_widget.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  bool typeScreen = true;
  Timer? timer;
  int hoursNumeric = 0;
  int minuteNumeric = 0;
  int secendNumeric = 0;
  Duration duration = const Duration();

  @override
  void initState() {

    reset();
    setState(() {});
    super.initState();
  }

  static Duration countdownDuration = const Duration();

  addTime() {
    const addSecend = -1;
    setState(() {
      final secend = duration.inSeconds + addSecend;
      if (secend < 0) {
        timer?.cancel();
      } else {
        duration = Duration(seconds: secend);
      }
    });
  }

  void startTime({bool resets = true}) {
    if (resets) {
      reset();
    }

    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  stop({bool resets = true}) {
    if (resets) {
      reset();
    }
    setState(() => timer?.cancel());
  }

  reset() {
    setState(() {
      countdownDuration = Duration(
          minutes: minuteNumeric,
          seconds: secendNumeric,
          hours: hoursNumeric);
      duration = countdownDuration;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: typeScreen ? buildTimerSetScreen() : buildTimerCountScreen(),
    );
  }

  Widget buildTimerCountScreen() {

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String secends = twoDigits(duration.inSeconds.remainder(60));
    String hours = twoDigits(duration.inHours);




    print('$hours   -  numeric:$hoursNumeric');
    print('$minutes   -  numeric:$minuteNumeric');
    print('$secends   -  numeric:$secendNumeric');

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
                  TimerWidget(hours: hours, minutes: minutes, secends: secends),
                  const Spacer(),
                ],
              ),
            ),
            SizedBox(
              height: size.height / 2,
              child: Center(child: Text('motivation cümleleri ve görselleri ')),
            ),
            buildButton(),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView buildTimerSetScreen() {
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
                    reset();
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
                      reset();
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
                    reset();
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
            child: InkWell(
                onTap: () {
                  setState(() {
                    startTime(resets: false);
                    typeScreen = false;
                  });
                },
                child: LoginSigninButtonWidget(color: primeryColor, txt: 'Go')),
          )
        ],
      ),
    );
  }

  Widget buildButton() {
    bool type = timer == null ? false : timer!.isActive;
    Size size = MediaQuery.of(context).size;
    final isComplated = duration.inSeconds == 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width / 25),
          child: InkWell(
            onTap: () {
              setState(() {
                if (type) {
                  stop(resets: false);
                } else {
                  startTime(resets: false);
                }
              });
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
                stop(resets: true);
                typeScreen = true;
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
