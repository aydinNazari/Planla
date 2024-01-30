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
      required this.controlCaptalWord,
      required this.onSubmited,
        required this.autofocusControl,
      required this.inputLenghtControl})
      : super(key: key);
  final String hintText;
  final Widget labelTextWidget;
  final Widget iconWidget;
  final bool obscrueText;
  final bool inputLenghtControl;
  final bool autofocusControl;
  final Color hintColor;
  final bool controlCaptalWord;
  final void Function(String) onSubmited;
  final void Function(String) onchange;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextField(
        autofocus: autofocusControl ? true : false,
        inputFormatters: [
          LengthLimitingTextInputFormatter(inputLenghtControl ? 20 : 60)
        ],
        textCapitalization: controlCaptalWord
            ? TextCapitalization.sentences
            : TextCapitalization.none,
        onChanged: onchange,
        onSubmitted: onSubmited,
        obscureText: obscrueText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          prefix: iconWidget,
          labelStyle: TextStyle(
            color: hintColor,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
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
