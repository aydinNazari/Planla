import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:planla/controls/firebase/auth.dart';
import 'package:planla/screens/Intro_screen_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:planla/screens/navigator_screen.dart';
import 'package:planla/widgets/account_button.widget.dart';
import '../utiles/constr.dart';
import '../widgets/button_loginsignin_widget.dart';
import '../widgets/textinputfield_widget.dart';

class LoginSignInScreen extends StatefulWidget {
  const LoginSignInScreen({Key? key}) : super(key: key);

  @override
  State<LoginSignInScreen> createState() => _LoginSignInScreenState();
}

class _LoginSignInScreenState extends State<LoginSignInScreen> {
  String _email = '';
  String _pass = '';
  String _name = '';
  bool viewControl = true;
  Uint8List? image;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return viewControl ? loginScreen(size) : signInScreen(size);
  }

//Login widget
  SafeArea loginScreen(Size size) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: size.height / 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: size.width / 4),
                      child: Container(
                        width: size.width,
                        height: size.height / 3,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('assets/images/goal.png'),
                        )),
                      ),
                    ),
                    Positioned(
                        bottom: size.height / 19,
                        right: size.width / 7,
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: 'Target',
                              style: TextStyle(
                                fontSize: size.width / 14,
                                color: Colors.black45,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: 'T',
                              style: TextStyle(
                                fontSize: size.width / 9,
                                color: Colors.black38,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: 'rack',
                              style: TextStyle(
                                fontSize: size.width / 14,
                                color: Colors.black45,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ]),
                        ))
                  ],
                )
                /*    Center(
                  child: Text(
                    'Planla',
                    style: TextStyle(
                        fontSize: size.width / 9,
                        fontWeight: FontWeight.w900,
                        color: Colors.black),
                  ),
                ),*/
                /*  Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: size.width / 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),*/
                ,
                Padding(
                  padding: EdgeInsets.only(
                    top: size.height / 45,
                  ),
                  child: TextInputField(
                    hintColor: Colors.black,
                    hintText: 'Enter your email address please...',
                    iconWidget: Padding(
                      padding: EdgeInsets.only(right: size.width / 25),
                      child: const Icon(Icons.mail),
                    ),
                    labelTextWidget: const Text('E-Mail'),
                    obscrueText: false,
                    onchange: (String s) {
                      _email = s;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: size.height / 25,
                    bottom: size.height / 25,
                  ),
                  child: TextInputField(
                    hintColor: Colors.black,
                    hintText: 'Enter your password please...',
                    iconWidget: Padding(
                      padding: EdgeInsets.only(right: size.width / 25),
                      child: const Icon(Icons.lock),
                    ),
                    labelTextWidget: const Text('Password'),
                    obscrueText: true,
                    onchange: (String s) {
                      _pass = s;
                    },
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if (_email.isNotEmpty && _pass.isNotEmpty) {
                      await loginFunction();
                    } else {
                      setState(() {
                        showSnackBar(
                          context,
                          'Please fill in all fields',
                          Colors.red,
                        );
                      });
                    }
                  },
                  child: /*Container(
                    width: size.width / 1.1,
                    height: size.height / 13,
                    decoration: const BoxDecoration(
                      color: Color(0xff803c48),
                    ),
                    child: Center(
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.width / 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),*/
                      const LoginSigninButtonWidget(
                    color: Color(0xff171818),
                    txt: 'Log in',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: size.height / 50),
                  child: InkWell(
                    onTap: () async {
                      bool res = await Auth().signInWithGoogle(context);
                      if (res) {
                        setState(() {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.bottomToTop,
                                  child: const NavigatorScreen()));
                        });
                      }
                    },
                    child: const AccountButtonWidget(
                      buttonColor: Colors.blue,
                      txt: 'Login with Google',
                      textColor: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: size.width / 25,
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        viewControl = false;
                      });
                    },
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Dont\'t have an account?',
                            style: TextStyle(
                              fontSize: size.width / 25,
                              fontWeight: FontWeight.w400,
                              color: Colors.black45,
                            ),
                          ),
                          TextSpan(
                            text: '  Register',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: size.width / 25,
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

//signIn widget
  SafeArea signInScreen(Size size) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: size.height / 20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /* Center(
                    child: Text(
                      'Planla',
                      style: TextStyle(
                        fontSize: size.width / 9,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Register',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: size.width / 18,
                          fontWeight: FontWeight.w800),
                    ),
                  ),*/
                  Center(
                    child: Text(
                      'TargetToTarget',
                      style: TextStyle(
                        fontSize: size.width / 9,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      Uint8List? pickerImage = await pickImager();
                      if (pickerImage != null) {
                        setState(() {
                          image = pickerImage;
                        });
                      }
                    },
                    child: image == null
                        ? Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: size.height / 50),
                                child: Container(
                                  width: size.width / 3,
                                  height: size.width / 3,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.person,
                                      size: size.width / 4,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: size.width / 20,
                                bottom: size.height / 40,
                                child: Icon(
                                  Icons.add_a_photo,
                                  color: Colors.white,
                                  size: size.width / 14,
                                ),
                              )
                            ],
                          )
                        : SizedBox(
                            width: size.width / 3,
                            height: size.width / 3,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(size.width / 2),
                              child: Image.memory(
                                fit: BoxFit.cover,
                                image!,
                              ),
                            ),
                          ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: size.height / 50,
                    ),
                    child: TextInputField(
                      hintColor: Colors.black,
                      hintText: 'Enter your name please...',
                      iconWidget: Padding(
                        padding: EdgeInsets.only(right: size.width / 25),
                        child: const Icon(Icons.person),
                      ),
                      labelTextWidget: const Text('Name'),
                      obscrueText: false,
                      onchange: (String s) {
                        _name = s;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: size.height / 50,
                    ),
                    child: TextInputField(
                      hintColor: Colors.black,
                      hintText: 'Enter your email address please...',
                      iconWidget: Padding(
                        padding: EdgeInsets.only(right: size.width / 25),
                        child: const Icon(Icons.mail),
                      ),
                      labelTextWidget: const Text('E-Mail'),
                      obscrueText: false,
                      onchange: (String s) {
                        _email = s;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: size.height / 50,
                      bottom: size.height / 80,
                    ),
                    child: TextInputField(
                      hintColor: Colors.black,
                      hintText: 'Enter your password please...',
                      iconWidget: Padding(
                        padding: EdgeInsets.only(
                          right: size.width / 25,
                        ),
                        child: const Icon(Icons.lock),
                      ),
                      labelTextWidget: const Text('Password'),
                      obscrueText: true,
                      onchange: (String s) {
                        _pass = s;
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (_email.isNotEmpty &&
                          _pass.isNotEmpty &&
                          _name.isNotEmpty) {
                        if (image == null) {
                          showMyDialog(context,size,
                              'Are you sure to proceed without uploading the profile picture?',
                              () async {
                            await signupProsess();
                          }, () {
                            Navigator.of(context).pop();
                          });
                        } else {
                          await signupProsess();
                        }
                      } else {
                        setState(() {
                          showSnackBar(
                              context, 'Please fill in all fields', Colors.red);
                        });
                      }
                    },
                    child: const LoginSigninButtonWidget(
                      color: Color(0xff000000),
                      txt: 'Sign in',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: size.height / 80),
                    child: const AccountButtonWidget(
                      buttonColor: Color(0xff3b91ea),
                      txt: 'Sign with Google',
                      textColor: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: size.width / 50,
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          viewControl = true;
                        });
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Already have an account?',
                              style: TextStyle(
                                fontSize: size.width / 25,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: '  Login',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: size.width / 22,
                                color: const Color(0xff673031),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //functions
  Future<void> loginFunction() async {
    lottieProgressDialog(context,'assets/json/progress.json');
    bool res = await Auth().loginUser(_email, _pass, context);
    if(context.mounted){
      Navigator.of(context).pop();
    }
    if (res) {
      setState(() {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.bottomToTop,
            child: const NavigatorScreen(),
          ),
        );
      });
    }
  }

  Future<void> signupProsess() async {
    lottieProgressDialog(context,'assets/json/progress.json');
    bool res =
        await Auth().signupUser(_email, _name, _pass, context, image);
    if(context.mounted){
      Navigator.of(context).pop();
    }
    if (res) {
      setState(() {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.bottomToTop,
                child: const IntroScreen()));
      });
    }
  }
}
