import 'package:flutter/material.dart';


class AddTextfieldWidget extends StatelessWidget {
 final void Function(String) onSubmit;

  AddTextfieldWidget({Key? key, required this.onSubmit}) : super(key: key);

  TextEditingController txtControoler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      child: TextField(
        textCapitalization: TextCapitalization.words,
        //maxLines: 5,
        //onEditingComplete: onSubmit,
        controller: txtControoler,
        onSubmitted: onSubmit,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: 'Add...',
          //icon: Icon(Icons.task_alt),
          hintStyle: TextStyle(
            color: Colors.white,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 2,color: Colors.white), // Kenarlık rengi
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
                color: Color(
                    0xff424874)), // İç kenarlık rengi (odaklandığında)
          ),
        ),
      ),
    );
  }
}
