import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
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
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      providerUser.user.name.length >=22 ?
                      Expanded(
                        child: Text(
                          providerUser.getLanguage
                              ? 'Selam ${providerUser.user.name}!'
                              : 'Hi ${providerUser.user.name}!',
                          softWrap: true,
                          style: TextStyle(shadows: const <Shadow>[
                            Shadow(
                                color: Colors.black,
                                blurRadius: 5,
                                offset: Offset(0, 0))
                          ], color: textColor, fontSize: size.width / 18),
                        ),
                      ) :Text(
                        providerUser.getLanguage
                            ? 'Selam ${providerUser.user.name}!'
                            : 'Hi ${providerUser.user.name}!',
                        softWrap: true,
                        style: TextStyle(shadows: const <Shadow>[
                          Shadow(
                              color: Colors.black,
                              blurRadius: 5,
                              offset: Offset(0, 0))
                        ], color: textColor, fontSize: size.width / 18),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: size.width / 50),
                        child: SizedBox(
                          width: size.width/15,
                            height: size.height/15,
                            child: Image.asset('assets/icons/hand_hello.png')),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: size.width / 25,
                    ),
                    child: InkWell(
                      autofocus: true,
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: const ProfileScreen(control: true)),
                          (route) => route.isCurrent,
                        );
                      },
                      child: SizedBox(
                        height: size.height/11,
                        width: size.width/15,
                        child: ProgileImgWidget(
                          url: providerUser.user.imageurl,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          /*  Padding(
              padding: EdgeInsets.only(top: size.height / 25),
              child: Text(
                providerUser.getLanguage
                    ? 'Geçen haftanın sonuçla'
                    : 'Last Week Result',
                style: TextStyle(
                    fontSize: size.width / 25,
                    color: textColor,
                    fontWeight: FontWeight.w600),
              ),
            ),*/
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
                providerUser.getLanguage ? 'Grafiğiniz' :
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
              padding: EdgeInsets.only(top: size.height / 25),
              child: Text(
                providerUser.getLanguage ? 'Kullanıcıların sıralaması' :
                'Ranking of users',
                style: TextStyle(
                    fontSize: size.width / 25,
                    color: textColor,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                right: size.width / 45,
                top: size.height / 35,
              ),
              child: SizedBox(
                  width: size.width,
                  height: size.height / 1.5,
                  child: const ArrangementCard()),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: size.height / 30, right: size.width / 50),
              child: SizedBox(
                width: size.width,
                height: size.height / 5,
                child: RecordWidget(size: size, providerUser: providerUser),
              ),
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
