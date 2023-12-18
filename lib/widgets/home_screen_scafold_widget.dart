import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:planla/widgets/profile_img_widget.dart';
import 'package:provider/provider.dart';

import '../controls/providersClass/provider_user.dart';
import '../screens/profile_screen.dart';
import '../utiles/colors.dart';
import 'chart_widget.dart';
import 'homepage_type_container_widget.dart';

class HomeScreenScafoldWidget extends StatefulWidget {
  const HomeScreenScafoldWidget({Key? key}) : super(key: key);

  @override
  State<HomeScreenScafoldWidget> createState() => _HomeScreenScafoldWidgetState();
}

class _HomeScreenScafoldWidgetState extends State<HomeScreenScafoldWidget> {
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    ProviderUser providerUser=Provider.of<ProviderUser>(context,listen: false);
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
                        child: const ProgileImgWidget(
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
                                padding:
                                EdgeInsets.only(right: size.width / 50),
                                child: const TypeContainerWidget(
                                    typeWidget: 1,
                                    txt: '5h',
                                    imgUrl: 'assets/images/work.png'),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                EdgeInsets.only(right: size.width / 50),
                                child: const TypeContainerWidget(
                                    typeWidget: 2,
                                    txt: '2h',
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
                                padding:
                                EdgeInsets.only(right: size.width / 50),
                                child: const TypeContainerWidget(
                                    typeWidget: 3,
                                    txt: '5h',
                                    imgUrl: 'assets/images/sport.png'),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                EdgeInsets.only(right: size.width / 50),
                                child: const TypeContainerWidget(
                                    typeWidget: 4,
                                    txt: '2h',
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
                  padding: EdgeInsets.only(top: size.height / 30),
                  child: Container(
                    width: size.width / 1.1,
                    height: size.height / 5,
                    decoration: BoxDecoration(
                        color: const Color(0xff4855e5),
                        borderRadius: BorderRadius.all(
                            Radius.circular(size.width / 15))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Your Record',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: size.width / 15,
                            shadows: const <Shadow>[
                              Shadow(
                                  color: Colors.white,
                                  blurRadius: 3,
                                  offset: Offset(0, 0))
                            ],
                          ),
                        ),
                        Text(
                          '100h',
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                            fontSize: size.width / 15,
                            shadows: const <Shadow>[
                              Shadow(
                                color: Colors.white70,
                                blurRadius: 2,
                                offset: Offset(0, 0),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
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
