import 'package:flutter/material.dart';

class TimerButtonWidget extends StatelessWidget {
  final Color color;
  final String txt;
  final bool radiusControl;

  const TimerButtonWidget({
    super.key,
    required this.color,
    required this.txt,
    required this.radiusControl,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(
            radiusControl ? size.width / 25 : 0,
          ),
        ),
        color: color,
      ),
      child: Center(
        child: Text(
          txt,
          style: TextStyle(
            fontSize: size.width / 18,
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
