import 'package:flutter/material.dart';
import 'package:planla/utiles/constr.dart';

class NavigatorScreen extends StatefulWidget {
  const NavigatorScreen({Key? key}) : super(key: key);

  @override
  State<NavigatorScreen> createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  int currentIndex = 0;

  void navigatorIndex(int value) {
    setState(() {
      currentIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: screenList[currentIndex],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(size.width / 45),
        child: Container(
          width: size.width,
          height: size.height / 11,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
            Radius.circular(
              size.width / 20,
            ),
          )),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (v) {
              navigatorIndex(v);
            },
            items: [
              BottomNavigationBarItem(
                backgroundColor: Colors.black,
                icon: Icon(
                  Icons.home_outlined,
                  size: size.width / 17,
                  color: Colors.white,
                ),
                activeIcon: Icon(
                  Icons.home,
                  size: size.width / 14,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.add_outlined,
                  size: size.width / 17,
                ),
                activeIcon: Icon(
                  Icons.add,
                  size: size.width / 14,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.analytics_outlined,
                  size: size.width / 17,
                ),
                activeIcon: Icon(
                  Icons.analytics,
                  size: size.width / 14,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_outline,
                  size: size.width / 17,
                ),
                activeIcon: Icon(
                  Icons.person,
                  size: size.width / 14,
                ),
                label: '',
              )
            ],
          ),
        ),
      ),
    );
  }
}
