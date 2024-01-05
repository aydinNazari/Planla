import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:planla/controls/providersClass/provider_user.dart';
import 'package:planla/models/today_model.dart';
import 'package:provider/provider.dart';

import '../../utiles/colors.dart';

class AddPageCardWidget extends StatelessWidget {
  final void Function() tikOntap;
  final void Function() importOntap;
  final int index;
  final List<TodayModel> cardList;
  final Color color;

  const AddPageCardWidget(
      {Key? key,
      required this.tikOntap,
      required this.importOntap,
      required this.index,
      required this.cardList,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final user = Provider.of<ProviderUser>(context, listen: false);
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height / 10,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(
            Radius.circular(size.width / 25),
          )),
      child: Padding(
        padding: EdgeInsets.only(left: size.width / 25),
        child: Row(
          children: [
            InkWell(
              onTap: tikOntap
              /*doneControl=!doneControl;
                setState(() {

                });*/
              ,
              child: cardList[index].done
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
                                color: primeryColor, shape: BoxShape.circle),
                          ),
                        ),
                      ),
                    ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: cardList[index].done ? 0 : size.width / 70),
              child: Text(
                cardList[index].text,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: size.width / 28,
                    decoration: cardList[index].done
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(
                  right: cardList[index].important
                      ? size.width / 50
                      : size.width / 25),
              child: InkWell(
                onTap: importOntap,
                child: cardList[index].important
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
    );
  }
}
