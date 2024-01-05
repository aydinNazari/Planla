import 'package:flutter/material.dart';


class LoginSignInTextFieldWidget extends StatelessWidget {
  final bool controlObsecure;
  final String hintText;
  final String txt;
  final void Function(String) onchange;
  const LoginSignInTextFieldWidget({
    super.key, required this.controlObsecure, required this.hintText, required this.txt, required this.onchange,
  });

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return TextField(
      onChanged: onchange,
      decoration: InputDecoration(
        label: Text(
          txt,
          style: TextStyle(
            fontSize: size.width / 28,
            color: Colors.grey,
          ),
        ),
        hintText: hintText,
        hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: size.width/27
        ),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(
            style: BorderStyle.solid,
            color: Colors.black, // Alt çizginin rengini istediğiniz renge ayarlayabilirsiniz
            width: 2.0, // Alt çizginin kalınlığını ayarlayabilirsiniz
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black, // Etkin halin rengi
          ),
        ),
      ),
      obscureText: controlObsecure,
    );
  }
}