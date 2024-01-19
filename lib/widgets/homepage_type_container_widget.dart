import 'package:flutter/material.dart';

class TypeContainerWidget extends StatelessWidget {
  final String imgUrl;
  final int typeWidget;

  const TypeContainerWidget(
      {Key? key,

      required this.imgUrl,
      required this.typeWidget})
      : super(key: key);

  //type ==1 -> study
  //type ==2 -> work
  //type ==3 -> sport
  //type ==4 -> other

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width / 3,
      height: size.height / 5,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(5, 5),
            ) // changes position of shadow),
          ],
          color: typeWidget == 1
              ? const Color(0xff4855e5)
              : typeWidget == 2
                  ? const Color(0xffe4ff3b)
                  : typeWidget == 3
                      ? const Color(0xff80ed99)
                      : const Color(0xff915eca),
          borderRadius: BorderRadius.all(
            Radius.circular(size.width / 20),
          )),
      child: Center(
        child: Padding(
          padding:  EdgeInsets.all(size.width/18),
          child: SizedBox(
            child: Image.asset(imgUrl),
          ),
        ),
      ),
    );
  }
}
