import 'package:flutter/material.dart';

class TypeContainerWidget extends StatelessWidget {
  final String txt;
  final String imgUrl;
  const TypeContainerWidget({Key? key, required this.txt, required this.imgUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Container(
      width: size.width / 3,
      height: size.height / 5,
      decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.all(
            Radius.circular(size.width / 20),
          )),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: size.width / 7,
                height: size.height / 10,
                child: Image.asset(imgUrl)),
            Text(
              txt,
              style: TextStyle(
                  shadows: const <Shadow>[
                    Shadow(
                        color:Colors.black,
                        blurRadius:4,
                        offset:Offset(0,0))
                  ],
                  color: Colors.black,
                  fontSize: size.width / 15,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}
