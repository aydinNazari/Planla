import 'package:flutter/material.dart';

class LoginSignInTextFieldWidget extends StatefulWidget {
  final bool controlObsecure;
  final String hintText;
  final String txt;
  final bool passControl;
  final void Function(String) onchange;

  const LoginSignInTextFieldWidget({
    super.key,
    required this.controlObsecure,
    required this.hintText,
    required this.txt,
    required this.onchange,
    required this.passControl,
  });

  @override
  State<LoginSignInTextFieldWidget> createState() =>
      _LoginSignInTextFieldWidgetState();
}

bool hidePass = true;

class _LoginSignInTextFieldWidgetState
    extends State<LoginSignInTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return TextField(
      onChanged: widget.onchange,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        suffix: widget.passControl ? InkWell(
          onTap: () {
            hidePass = !hidePass;
            setState(() {});
          },
          child: hidePass
              ? const Icon(Icons.visibility)
              : const Icon(Icons.visibility_off),
        ) : const SizedBox(),
        label: Text(
          widget.txt,
          style: TextStyle(
            fontSize: size.width / 28,
            color: Colors.grey,
          ),
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Colors.grey, fontSize: size.width / 27),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(
            style: BorderStyle.solid,
            color: Colors.black,
            // Alt çizginin rengini istediğiniz renge ayarlayabilirsiniz
            width: 2.0, // Alt çizginin kalınlığını ayarlayabilirsiniz
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black, // Etkin halin rengi
          ),
        ),
      ),
      obscureText: widget.controlObsecure ? hidePass : false,
    );
  }
}
