import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:planla/controls/firebase/firestore._methods.dart';
import 'package:planla/controls/providersClass/provider_user.dart';
import 'package:planla/screens/Intro_screen_page.dart';
import 'package:planla/utiles/colors.dart';
import 'package:provider/provider.dart';

class SelectLanguageScreen extends StatefulWidget {
  const SelectLanguageScreen({Key? key}) : super(key: key);

  @override
  State<SelectLanguageScreen> createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  String valueLan = 'English';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ProviderUser providerUser = Provider.of<ProviderUser>(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: size.width / 20,
                right: size.width / 20,
                top: size.height / 25),
            child: SizedBox(
              width: size.width,
              height: size.height / 3,
              child: Lottie.network(
                  'https://lottie.host/04585743-324e-4bb9-9b14-cbe4000695c2/LhMnYD3Sdo.json'),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: size.height / 8),
            child: SizedBox(
              width: size.width / 2,
              height: size.height / 10,
              child: DropdownButton(
                alignment: Alignment.center,
                dropdownColor: const Color(0xffc9cfd5),
                icon: const Icon(Icons.language),
                items: [
                  DropdownMenuItem<String>(
                    alignment: Alignment.center,
                    value: 'English',
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: size.width / 100),
                          child: SizedBox(
                              width: size.width / 12,
                              child: Image.asset('assets/images/uk-flag.png')),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: size.width / 25),
                          child: const Text('English'),
                        ),
                      ],
                    ),
                  ),
                  DropdownMenuItem<String>(
                    alignment: Alignment.center,
                    value: 'Türkçe',
                    child: Row(
                      children: [
                        SizedBox(
                            width: size.width / 10,
                            child: Image.asset('assets/images/turkey.png')),
                        Padding(
                          padding: EdgeInsets.only(left: size.width / 25),
                          child: const Text('Türkçe'),
                        ),
                      ],
                    ),
                  ),
                ],
                isExpanded: true,
                value: valueLan,
                borderRadius:
                    BorderRadius.all(Radius.circular(size.width / 25)),
                onChanged: (Object? value) {
                  if (value is String) {
                    if (value == 'English') {
                      providerUser.setLanguage(false);
                      valueLan = value;
                    } else {
                      providerUser.setLanguage(true);
                      valueLan = value;
                    }
                  }
                  setState(() {});
                },
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: size.height / 7),
            child: InkWell(
              onTap: () async {
               // providerUser.setEnterControl(true);
                await FirestoreMethods().setLanguage(
                  context,valueLan
                );
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                      type: PageTransitionType.leftToRight,
                      child: const IntroScreen(),
                    ),
                  );
                }
              },
              child: Container(
                width: size.width / 3,
                height: size.height / 12,
                decoration: BoxDecoration(
                  color: const Color(0xff4989f3),
                  borderRadius: BorderRadius.all(
                    Radius.circular(size.width / 25),
                  ),
                ),
                child: Center(
                  child: Text(
                    providerUser.getLanguage ? 'Tamam' : 'Ok',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width / 22,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
