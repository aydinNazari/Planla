import 'package:flutter/material.dart';
import 'package:planla/controls/providersClass/provider_user.dart';
import 'package:planla/screens/navigator_screen.dart';
import 'package:planla/utiles/colors.dart';
import 'package:provider/provider.dart';
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
    ProviderUser providerUser =
        Provider.of<ProviderUser>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding:
                  EdgeInsets.only(right: size.width / 25, top: size.width / 25),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NavigatorScreen(),
                    ),
                  );
                },
                child: Text(
                  providerUser.getLanguage ? 'Atla' : 'Skip',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: size.width / 20),
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
              children: [
                IntroScreenWidget(
                  revers: false,
                  img: 'assets/images/work.png',
                  title: providerUser.getLanguage
                      ? 'Görev Takipçisi'
                      : 'Task Tracker',
                  content: providerUser.getLanguage
                      ? 'Kolay görev kaydı ve anlayışlı ilerleme analizi ile üretkenliği artırın'
                      : 'Elevate productivity with easy task logging and insightful progress analysis',
                ),
                IntroScreenWidget(
                  revers: true,
                  img: 'assets/images/study.png',
                  title: providerUser.getLanguage
                      ? 'Görev Yöneticisi'
                      : 'Task Master',
                  content: providerUser.getLanguage
                      ? 'Akıllı ilerleme takibiyle önceliklendirin, başarın ve daha az stres yapın'
                      : 'Prioritize, achieve, and stress less with smart progress tracking',
                ),
                IntroScreenWidget(
                    revers: false,
                    img: 'assets/images/other.png',
                    title:
                        providerUser.getLanguage ? 'Görev Formu' : 'Task Form',
                    content: providerUser.getLanguage
                        ? 'Hayallerinizi günlük kazanımlara, planlamaya ve hedeflere ulaşmaya dönüştürme rehberiniz'
                        : 'Your guide to turning dreams into daily wins, planning, and conquering goals')
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: size.height / 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildIndicator(size),
              ),
            )
          ],
        ),
      ),
    );
  }

  // alttaki hangi sayfada olduğan belirti widgitları

  Widget _indicator(bool isActive, Size size) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: size.height / 80,
      width: isActive ? size.width / 20 : size.width / 55,
      margin: EdgeInsets.only(right: size.width / 55),
      decoration: BoxDecoration(
        color: primeryColor,
        borderRadius: BorderRadius.all(
          Radius.circular(size.width / 50),
        ),
      ),
    );
  }

  List<Widget> _buildIndicator(Size size) {
    List<Widget> indicator = [];
    for (int i = 0; i < 3; i++) {
      if (currentIndex == i) {
        indicator.add(_indicator(true, size));
      } else {
        indicator.add(_indicator(false, size));
      }
    }
    return indicator;
  }
}
