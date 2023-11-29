import 'package:flutter/material.dart';

class AccountButtonWidget extends StatelessWidget {
  final Color buttonColor;
  final String txt;
  final Color textColor;

  const AccountButtonWidget(
      {Key? key,
      required this.buttonColor,
      required this.txt,
      required this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width / 1.1,
      height: size.height / 13,
      child: Container(
        color: buttonColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: size.width / 15,
              height: size.width / 15,
              child: Image.asset(
                'assets/icons/google.png',
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: size.width / 35),
              child: Text(
                txt,
                style: TextStyle(
                    color: textColor,
                    fontSize: size.width / 22,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
