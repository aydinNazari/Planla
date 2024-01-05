import 'package:flutter/material.dart';

class LoginSigninButtonWidget extends StatelessWidget {
  final bool iconControl;
  final String iconUrl;
  final String txt;
  const LoginSigninButtonWidget({
    super.key, required this.iconControl, required this.iconUrl, required this.txt,
  });

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
                offset:Offset(0,5),
                blurRadius:2,
                color:Colors.black38
            )
          ],
          color: Colors.black,
          borderRadius: BorderRadius.all(
            Radius.circular(size.width / 10),
          )),
      child: Center(
        child:iconControl ? SizedBox(
            width: size.width/25,
            height: size.width/25,
            child: Image.asset(iconUrl)) :Text(
          txt,
          style: TextStyle(
              color: const Color(0xffcdd7d9),
              fontSize: size.width / 25,
              fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}