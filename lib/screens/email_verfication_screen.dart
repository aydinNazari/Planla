import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:planla/screens/Intro_screen_page.dart';
import 'package:planla/screens/login_signin_screen.dart';
import 'package:planla/utiles/colors.dart';

import '../utiles/constr.dart';

class EmailVerfication extends StatelessWidget {
  const EmailVerfication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size.width,
            height: size.height / 4,
            child: Image.asset('assets/images/verification.png'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: size.height / 25, horizontal: size.width / 15),
            child: Text(
              'Kindly verify your email by checking your inbox for our message',
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(
                color: const Color(0xff4a5c73),
                fontSize: size.width / 22,
              ),
            ),
          ),
          SizedBox(
            height: size.height / 6,
          ),
          InkWell(
            onTap: () {
              if (!auth.currentUser!.emailVerified) {
                Navigator.pushReplacement(
                    context,
                    PageTransition(
                        type: PageTransitionType.leftToRight,
                        child: const LoginSignInScreen()));
              }else{
                Navigator.pushReplacement(
                    context,
                    PageTransition(
                        type: PageTransitionType.leftToRight,
                        child: const IntroScreen()));
              }
            },
            child: Container(
              width: size.width / 3,
              height: size.height / 12,
              decoration: BoxDecoration(
                  color: primeryColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(size.width / 60),
                  )),
              child: Center(
                child: Text(
                  'Done',
                  style:
                      TextStyle(color: Colors.white, fontSize: size.width / 22),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
