

import 'package:flutter/material.dart';
import 'package:planla/utiles/colors.dart';

class TimerWidget extends StatelessWidget {
  final String hours;
  final String minutes;
  final String secends;


  const TimerWidget({Key? key, required this.hours, required this.minutes, required this.secends}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return Row(
      children: [
        buildTimeCard(hours, 'HOURS',context),
        SizedBox(
          width: size.width / 50,
        ),
        buildTimeCard(minutes, 'MINUTES',context),
        SizedBox(
          width: size.width / 50,
        ),
        buildTimeCard(secends, 'SECENDS',context),
      ],
    );
  }

  Widget buildTimeCard(String txt, String header,BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: primeryColor,
              borderRadius: BorderRadius.all(
                Radius.circular(size.width / 20),
              )),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width / 50),
            child: Text(
              txt,
              style: TextStyle(
                  fontSize: size.width / 5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: size.height / 100),
          child: Center(
            child: Text(
              header,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black38,
                  fontSize: size.width / 25),
            ),
          ),
        )
      ],
    );
  }
}
