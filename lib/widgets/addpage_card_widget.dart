import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:planla/models/today_model.dart';

import '../utiles/colors.dart';

class AddPageCardWidget extends StatefulWidget {
  final TodayModel todayModel;

  const AddPageCardWidget({Key? key, required this.todayModel})
      : super(key: key);

  @override
  State<AddPageCardWidget> createState() => _AddPageCardWidgetState();
}

class _AddPageCardWidgetState extends State<AddPageCardWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    importantControl = widget.todayModel.important;
    doneControl = widget.todayModel.done;
  }

  bool doneControl = false;
  bool importantControl = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: size.height / 50, right: size.width / 25),
      child: Container(
        width: size.width,
        height: size.height / 10,
        decoration: BoxDecoration(
            color: navigatorColor,
            borderRadius: BorderRadius.all(Radius.circular(size.width / 25))),
        child: Padding(
          padding: EdgeInsets.only(left: size.width / 25),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    doneControl = !doneControl;
                  });
                },
                child: doneControl
                    ? SizedBox(
                        width: size.width / 12,
                        height: size.width / 12,
                        child: Lottie.asset(
                          'assets/json/addpage_done.json',
                          repeat: false,
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(left: size.width / 50),
                        child: Container(
                          width: size.width / 20,
                          height: size.width / 20,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Container(
                              width: size.width / 23,
                              height: size.width / 23,
                              decoration: BoxDecoration(
                                  color: navigatorColor,
                                  shape: BoxShape.circle),
                            ),
                          ),
                        ),
                      ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: doneControl ? 0 : size.width / 70),
                child: Text(
                  widget.todayModel.text,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: size.width / 28,
                      decoration: doneControl
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                ),
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.only(
                    right:
                        importantControl ? size.width / 50 : size.width / 25),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      importantControl = !importantControl;
                    });
                  },
                  child: importantControl
                      ? SizedBox(
                          width: size.width / 10,
                          height: size.width / 10,
                          child: Lottie.asset('assets/json/addpage_star.json',
                              repeat: false),
                        )
                      : Icon(
                          Icons.star_border,
                          size: size.width / 15,
                          color: const Color(0xff457896),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
