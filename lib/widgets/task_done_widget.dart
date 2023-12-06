import 'package:flutter/material.dart';

class TasksCountWidget extends StatelessWidget {
  final String txt;
  final String count;

  const TasksCountWidget({
    super.key,
    required this.size,
    required this.txt,
    required this.count,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          txt,
          style:
          TextStyle(fontWeight: FontWeight.w600, fontSize: size.width / 20,color: Colors.black),
        ),
        Text(
          count,
          style: TextStyle(fontSize: size.width / 25,color: Colors.black),
        ),
      ],
    );
  }
}