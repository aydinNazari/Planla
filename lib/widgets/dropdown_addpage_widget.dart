import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:planla/controls/providersClass/provider_user.dart';
import 'package:provider/provider.dart';

class DropdownAddpageWidget extends StatefulWidget {
   const DropdownAddpageWidget({Key? key}) : super(key: key);

  @override
  State<DropdownAddpageWidget> createState() => _DropdownAddpageWidgetState();
}

class _DropdownAddpageWidgetState extends State<DropdownAddpageWidget> {
  final List<String> items = [
    'Study',
    'Work',
    'Sport',
    'other',
  ];

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: const Text(
          'Select Item',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        items: items
            .map((String item) => DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ))
            .toList(),
        value: selectedValue,
        onChanged: (String? value) {
            setState(() {
              selectedValue = value;
            });


        },
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16),
          height: 40,
          width: 140,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),
      ),
    );
  }
}
