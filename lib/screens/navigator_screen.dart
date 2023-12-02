import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:planla/controls/providersClass/provider_user.dart';
import 'package:planla/screens/add_screen.dart';
import 'package:planla/utiles/constr.dart';
import 'package:provider/provider.dart';

import '../utiles/colors.dart';
import '../widgets/profile_img_widget.dart';

class NavigatorScreen extends StatefulWidget {
  const NavigatorScreen({Key? key}) : super(key: key);

  @override
  State<NavigatorScreen> createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  int currentIndex = 1;

  void navigatorIndex(int value) {
    setState(() {
      currentIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //final user = Provider.of<ProviderUser>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: false,
        body: screenList[currentIndex],
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
              top: size.height / 5,
              left: size.width / 3.5,
              right: size.width / 3.5,
              bottom: size.height / 80),
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(size.width / 2),
            ),
            child: BottomNavigationBar(
              selectedItemColor: Colors.black,
              backgroundColor: navigatorColor,
              //backgroundColor: const Color(0xff4c956c),
              currentIndex: currentIndex,
              onTap: (v) {
                navigatorIndex(v);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home_outlined,
                    size: size.width / 17,
                    color: const Color(0xffdcd6f7),
                  ),
                  activeIcon: Icon(
                    Icons.home,
                    color: const Color(0xffa6b1e1),
                    size: size.width / 14,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: /* Icon(
                    Icons.add_outlined,
                    size: size.width / 17,
                  ),*/
                      SizedBox(
                    width: size.width / 10,
                    height: size.width / 10,
                    child: Lottie.asset('assets/json/add.json', repeat: false),
                  ),
                  activeIcon: SizedBox(
                    width: size.width / 10,
                    height: size.width / 10,
                    child: Lottie.asset(
                      'assets/json/add.json',
                      repeat: false,
                    ),
                  ),
                  label: '',
                ),
                /*     BottomNavigationBarItem(
                  icon: Icon(
                    Icons.analytics_outlined,
                    size: size.width / 17,
                  ),
                  activeIcon: Icon(
                    Icons.analytics,
                    size: size.width / 14,
                  ),
                  label: '',
                ),*/
                const BottomNavigationBarItem(
                  icon: /*Icon(
                    Icons.person_outline,
                    size: size.width / 17,
                  )*/
                      ProgileImgWidget(type: 0),
                  activeIcon: /*Icon(
                    Icons.person,
                    size: size.width / 14,
                  ),*/
                      /*  Container(
                    width: size.width / 14,
                    height: size.width / 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: user.user.imageurl.isEmpty ?
                        const AssetImage('assets/icons/person_icon.png') :
                        NetworkImage(user.user.imageurl) as ImageProvider<Object>,
                      ),
                    ),
                  ),*/
                      ProgileImgWidget(type: 0),
                  /*CachedNetworkImage(
         imageUrl: "http://via.placeholder.com/350x150",
         progressIndicatorBuilder: (context, url, downloadProgress) =>
                 CircularProgressIndicator(value: downloadProgress.progress),
         errorWidget: (context, url, error) => Icon(Icons.error),
      ),
                  */
                  label: '',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
