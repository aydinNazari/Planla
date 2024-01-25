import 'package:flutter/material.dart';
import 'package:planla/controls/providersClass/provider_user.dart';
import 'package:planla/utiles/colors.dart';

class TimerWidget extends StatelessWidget {
  final String hours;
  final String minutes;
  final String secends;
  final ProviderUser providerUser;

  const TimerWidget(
      {Key? key,
      required this.hours,
      required this.minutes,
      required this.secends,required this.providerUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      children: [

        buildTimeCard(hours, providerUser.getLanguage ? 'SAAT':'HOURS', context),
        buildColon(size),
        buildTimeCard(minutes, providerUser.getLanguage ? 'DAKİKA':'MINUTES', context),
        buildColon(size),
        buildTimeCard(secends, providerUser.getLanguage ? 'SANİYE':'SECENDS', context),
      ],
    );
  }

  Widget buildColon(Size size) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(bottom:size.height/35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: size.height/50,
                width: size.width / 20,
                decoration:  BoxDecoration(
                  color: primeryColor,
                  shape: BoxShape.circle
                ),

              ),
              Padding(
                padding: EdgeInsets.only(top: size.height/80),
                child: Container(
                  height: size.height/50,
                  width: size.width / 20,
                  decoration:  BoxDecoration(
                      color: primeryColor,
                      shape: BoxShape.circle
                  ),

                ),
              ),
            ],
          ),
      ),
    );
  }

  Widget buildTimeCard(String txt, String header, BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: primeryColor,
              borderRadius: BorderRadius.all(
                Radius.circular(size.width / 20),
              )),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width / 50),
            child: Text(
              txt,
              style: TextStyle(
                  fontSize: size.width / 5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: size.height / 100),
          child: Center(
            child: Text(
              header,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black38,
                  fontSize: size.width / 25),
            ),
          ),
        )
      ],
    );
  }
}
