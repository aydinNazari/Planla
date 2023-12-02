import 'package:flutter/material.dart';

class AddTextfieldWidget extends StatelessWidget {
  final void Function(String) onSubmit;
   AddTextfieldWidget({Key? key, required this.onSubmit}) : super(key: key);

  TextEditingController txtControoler=TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return  Padding(
      padding: EdgeInsets.only(right: size.width/25),
      child:  TextField(
        controller: txtControoler,
        onSubmitted:onSubmit,
        style: const TextStyle(
            color: Colors.white
        ),
        decoration: const InputDecoration(
          hintText:'Add...',
          icon: Icon(Icons.task_alt),
          hintStyle: TextStyle(
            color: Colors.white,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red), // Kenarlık rengi
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff424874)), // İç kenarlık rengi (odaklandığında)
          ),
        ),
      ),
    );
  }
}
