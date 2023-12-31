import 'package:flutter/material.dart';
import 'package:planla/screens/navigator_screen.dart';
import 'package:planla/utiles/colors.dart';
import '../widgets/intro_screen_widget.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  late PageController _pageController;
  int currentIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20, top: 20),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NavigatorScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Skip',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 18),
                ),
              ),
            ),
          ],
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView(
              onPageChanged: (int page) {
                setState(() {
                  currentIndex = page;
                });
              },
              controller: _pageController,
              children: const [
                IntroScreenWidget(
                  revers: false,
                  img: 'assets/images/work.png',
                  title: 'TaskTracker',
                  content: 'Elevate productivity with easy task logging and insightful progress analysis',
                ),
                IntroScreenWidget(
                    revers: true,
                    img: 'assets/images/study.png',
                    title: 'TaskMaster',
                    content:
                        'Prioritize, achieve, and stress less with smart progress tracking',

                ),
                IntroScreenWidget(
                  revers: false,
                    img: 'assets/images/other.png',
                    title: 'TaskForge',
                    content:
                        'Your guide to turning dreams into daily wins, planning, and conquering goals',

                )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildIndicator(),
              ),
            )
          ],
        ),
      ),
    );
  }

  // alttaki hangi sayfada olduğan belirti widgitları

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 8,
      width: isActive ? 30 : 8,
      margin: const EdgeInsets.only(right: 5),
      decoration:  BoxDecoration(
        color: primeryColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
    );
  }

  List<Widget> _buildIndicator() {
    List<Widget> indicator = [];
    for (int i = 0; i < 3; i++) {
      if (currentIndex == i) {
        indicator.add(_indicator(true));
      } else {
        indicator.add(_indicator(false));
      }
    }
    return indicator;
  }
}
