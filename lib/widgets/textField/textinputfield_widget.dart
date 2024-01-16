import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInputField extends StatelessWidget {
  const TextInputField(
      {Key? key,
      required this.hintText,
      required this.labelTextWidget,
      required this.iconWidget,
      required this.obscrueText,
      required this.onchange,
      required this.hintColor,
      required this.inputLenghtControl})
      : super(key: key);
  final String hintText;
  final Widget labelTextWidget;
  final Widget iconWidget;
  final bool obscrueText;
  final bool inputLenghtControl;
  final Color hintColor;
  final void Function(String) onchange;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(inputLenghtControl ? 10 : 60)
        ],
        textCapitalization: TextCapitalization.words,
        onChanged: onchange,
        obscureText: obscrueText,
        decoration: InputDecoration(
          hintText: hintText,
          prefix: iconWidget,
          labelStyle: TextStyle(
            color: hintColor,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          label: labelTextWidget,
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
