import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:planla/screens/profile_screen.dart';
import 'package:planla/widgets/homepage_type_container_widget.dart';
import 'package:provider/provider.dart';

import '../controls/providersClass/provider_user.dart';
import '../widgets/chart_widget.dart';
import '../widgets/profile_img_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   /* var r=Provider.of<ProviderUser>(context,listen: false);
    var user=r.user;
    user.doneCount=0;
    user.taskCount=0;
    r.setUser(user);*/
  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<ProviderUser>(context, listen: false);
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.only(left: size.width / 25),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Hi ${user.user.name}!',
                  style: TextStyle(shadows: const <Shadow>[
                    Shadow(
                        color: Colors.white,
                        blurRadius: 5,
                        offset: Offset(0, 0))
                  ], color: Colors.white, fontSize: size.width / 15),
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
                              child: const ProfileScreen(control:true),
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
                style:
                    TextStyle(fontSize: size.width / 25, color: Colors.white60),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height/50),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: size.width / 50),
                      child: const TypeContainerWidget(
                          txt: '5h', imgUrl: 'assets/images/work.png'),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: size.width / 50),
                      child: const TypeContainerWidget(
                          txt: '2h', imgUrl: 'assets/images/sport.png'),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: size.width / 50),
                      child: const TypeContainerWidget(
                          txt: '10h', imgUrl: 'assets/images/study.png'),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height / 25),
              child: Text(
                'Your Chart',
                style:
                    TextStyle(fontSize: size.width / 25, color: Colors.white60),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height / 50),
              child: const ChartWidget()
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height / 30),
              child: Container(
                width: size.width / 1.1,
                height: size.height / 5,
                decoration: BoxDecoration(
                    color: const Color(0xffe0ff63),
                    borderRadius:
                        BorderRadius.all(Radius.circular(size.width / 15))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Your Record',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: size.width / 15,
                        shadows: const <Shadow>[
                          Shadow(
                              color: Colors.black,
                              blurRadius: 3,
                              offset: Offset(0, 0))
                        ],
                      ),
                    ),
                    Text(
                      '100h',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: size.width / 15,
                        shadows: const <Shadow>[
                          Shadow(
                            color: Colors.black,
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


