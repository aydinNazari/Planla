import 'package:flutter/material.dart';

class IntroScreenWidget extends StatelessWidget {
  final String img;
  final String title;
  final String content;
  final bool revers;

  const IntroScreenWidget(
      {Key? key, required this.img, required this.title, required this.content, required this.revers,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(bottom: size.height/8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              !revers
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: size.width / 1.6,
                            child: Image.asset(img, fit: BoxFit.cover)),
                        SizedBox(
                          height: size.height / 30,
                        )
                      ],
                    )
                  : const SizedBox(),
              Text(
                title,
                style: TextStyle(
                    color: const Color(0xff1b1e23),
                    fontSize: size.width / 13,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height / 50),
              Text(
                content,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xff75757a),
                  fontSize: size.width / 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              revers
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: size.width / 1.6,
                            child: Image.asset(img, fit: BoxFit.cover)),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
