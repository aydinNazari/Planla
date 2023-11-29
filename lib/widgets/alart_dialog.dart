import 'package:flutter/material.dart';

class AlartDialogWidget extends StatelessWidget {
  final String txt;
  final void Function() yesFunction;
  final void Function() noFunction;

  const AlartDialogWidget({Key? key, required this.txt, required this.yesFunction, required this.noFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        txt,
        textScaleFactor: 5,
      ),
      content: const SingleChildScrollView(
        // won't be scrollable
        child: Text('Scrollable content', textScaleFactor: 5),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: yesFunction,
          child: const Text('Yes'),
        ),
        TextButton(
          onPressed: noFunction,
          child: const Text('No'),
        ),
      ],
    );
  }
}
