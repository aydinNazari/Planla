import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:planla/controls/providersClass/timer_provider.dart';
import 'package:planla/widgets/profile_img_widget.dart';
import 'package:planla/widgets/card/record_widget.dart';
import 'package:provider/provider.dart';
import '../controls/providersClass/provider_user.dart';
import '../screens/profile_screen.dart';
import '../utiles/colors.dart';
import 'card/arrangment_card.dart';
import 'card/chart_widget.dart';
import 'homepage_type_container_widget.dart';

class HomeScreenScafoldWidget extends StatefulWidget {
  const HomeScreenScafoldWidget({Key? key}) : super(key: key);

  @override
  State<HomeScreenScafoldWidget> createState() =>
      _HomeScreenScafoldWidgetState();
}

class _HomeScreenScafoldWidgetState extends State<HomeScreenScafoldWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ProviderUser providerUser =
        Provider.of<ProviderUser>(context, listen: false);
  /*  TimerProvider timerProvider =
        Provider.of<TimerProvider>(context, listen: false);
    print('ffffff');
    print(timerProvider.getTempScore);*/
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          top: size.height / 40,
          left: size.width / 50,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Hi ${providerUser.user.name}!',
                  style: TextStyle(shadows: const <Shadow>[
                    Shadow(
                        color: Colors.black,
                        blurRadius: 5,
                        offset: Offset(0, 0))
                  ], color: textColor, fontSize: size.width / 15),
                ),
                Padding(
                  padding: EdgeInsets.only(left: size.width / 50),
                  child: SizedBox(
                      width: size.width / 10,
                      height: size.height / 10,
                      child: Image.asset('assets/icons/hand_hello.png')),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(
                    right: size.width / 25,
                  ),
                  child: InkWell(
                    autofocus: true,
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: const ProfileScreen(control: true),
                              isIos: true));
                    },
                    child:  ProgileImgWidget(
                      url: providerUser.user.imageurl,
                      type: 1,
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height / 25),
              child: Text(
                'Last Week Result',
                style: TextStyle(
                    fontSize: size.width / 25,
                    color: textColor,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height / 50),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: size.width / 50),
                            child: const TypeContainerWidget(
                                typeWidget: 1,
                                imgUrl: 'assets/images/work.png'),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: size.width / 50),
                            child: const TypeContainerWidget(
                                typeWidget: 2,
                                imgUrl: 'assets/images/study.png'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: size.width / 50),
                            child: const TypeContainerWidget(
                                typeWidget: 3,
                                imgUrl: 'assets/images/sport.png'),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: size.width / 50),
                            child: const TypeContainerWidget(
                                typeWidget: 4,
                                imgUrl: 'assets/images/other.png'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height / 25),
              child: Text(
                'Your Chart',
                style: TextStyle(
                    fontSize: size.width / 25,
                    color: textColor,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: size.height / 50),
                child: const ChartWidget()),
            Padding(
              padding: EdgeInsets.only(
                  top: size.height / 30, right: size.width / 50),
              child: SizedBox(
                width: size.width,
                height: size.height / 5,
                child: RecordWidget(size: size, providerUser: providerUser),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                right: size.width / 45,
                top: size.height / 25,
              ),
              child: SizedBox(
                  width: size.width,
                  height: size.height / 3,
                  child: const ArrangementCard()),
            ),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    ));
  }
}
