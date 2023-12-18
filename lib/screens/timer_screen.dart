import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:planla/widgets/add_textfield_widget.dart';

import '../widgets/button_loginsignin_widget.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height / 20,
            ),
            SizedBox(
              width: size.width,
              height: size.height / 3,
              child: CircularPercentIndicator(
                radius: size.height / 7,
                lineWidth: size.width / 50,
                percent: 1,
                center: const Text("100%"),
                reverse: true,
                animation: true,
                header: const Text('ffff'),
                progressColor: Colors.green,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: size.height / 25, top: size.height / 25),
              child: SizedBox(
                width: size.width / 2,
                height: size.height / 5,
                child: AddTextfieldWidget(onSubmit: (v) {}),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: size.width / 3, right: size.width / 3),
              child:
                  const LoginSigninButtonWidget(color: Colors.blue, txt: 'Go'),
            )
          ],
        ),
      ),
    );
  }
}
