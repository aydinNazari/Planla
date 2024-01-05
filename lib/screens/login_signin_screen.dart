import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:planla/controls/firebase/auth.dart';
import 'package:planla/screens/Intro_screen_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:planla/screens/navigator_screen.dart';
import 'package:planla/widgets/buttons/login_signin_button_widget.dart';
import '../utiles/colors.dart';
import '../utiles/constr.dart';
import '../widgets/textField/login_signin_textfield_widget.dart';

class LoginSignInScreen extends StatefulWidget {
  const LoginSignInScreen({Key? key}) : super(key: key);

  @override
  State<LoginSignInScreen> createState() => _LoginSignInScreenState();
}

class _LoginSignInScreenState extends State<LoginSignInScreen> {
  String _email = '';
  String _pass = '';
  String _name = '';
  int viewControl = 0;
  Uint8List? image;

  //viewControl=> log in
  //viewControl=> sign in
  //viewControl=> forgot passs

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return viewControl == 0
        ? loginScreen(size)
        : viewControl == 1
            ? signInScreen(size)
            : fogetPassScreen(size);
  }

//Login widget
  SafeArea loginScreen(Size size) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: loginScreenBackground,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: size.width / 25),
              child: InkWell(
                onTap: () {
                  setState(() {
                    viewControl = 1;
                  });
                },
                child: Text(
                  'Sign up',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontSize: size.width / 22,
                  ),
                ),
              ),
            )
          ],
        ),
        backgroundColor: loginScreenBackground,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                left: size.width / 25,
                top: size.height / 8,
                right: size.width / 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Log in',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: size.width / 18,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: size.height / 20),
                  child: LoginSignInTextFieldWidget(
                    onchange: (v) {
                      _email = v;
                    },
                    txt: 'Your Email',
                    controlObsecure: false,
                    hintText: 'Email',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: size.height / 25),
                  child: LoginSignInTextFieldWidget(
                    onchange: (v) {
                      _pass = v;
                    },
                    txt: 'Password',
                    controlObsecure: true,
                    hintText: 'Password',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: size.height / 20,
                  ),
                  child: InkWell(
                      onTap: () async {
                        if (_email.isNotEmpty && _pass.isNotEmpty) {
                          await loginFunction(_email, _pass);
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
                      child: SizedBox(
                          width: size.width,
                          height: size.height / 13,
                          child: const LoginSigninButtonWidget(
                            iconControl: false,
                            iconUrl: '',
                            txt: 'Log in',
                          ))),
                ),
                Padding(
                  padding: EdgeInsets.only(top: size.height / 45),
                  child: buildAccountButton(size),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: size.height / 40,
                  ),
                  child: Row(
                    children: [
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          setState(() {
                            viewControl = 1;
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
                      const Spacer(),
                    ],
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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: signinScreenBackground,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: size.width / 25),
              child: InkWell(
                onTap: () {
                  setState(() {
                    viewControl = 0;
                  });
                },
                child: Text(
                  'Log in',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontSize: size.width / 22,
                  ),
                ),
              ),
            )
          ],
        ),
        backgroundColor: signinScreenBackground,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /*Center(
                  child: Text(
                    'TargetToTarget',
                    style: TextStyle(
                      fontSize: size.width / 15,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                ),*/
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
                                width: size.width / 4,
                                height: size.width / 4,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.person,
                                    size: size.width / 6,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: size.width / 30,
                              bottom: size.height / 40,
                              child: Icon(
                                Icons.add_a_photo,
                                color: Colors.white,
                                size: size.width / 35,
                              ),
                            )
                          ],
                        )
                      : SizedBox(
                          width: size.width / 4,
                          height: size.width / 4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(size.width / 2),
                            child: Image.memory(
                              fit: BoxFit.cover,
                              image!,
                            ),
                          ),
                        ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width / 25, vertical: size.height / 30),
                  child: LoginSignInTextFieldWidget(
                    controlObsecure: false,
                    hintText: 'Name',
                    txt: 'Your Name',
                    onchange: (v) {
                      _name = v;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width / 25,
                  ),
                  child: LoginSignInTextFieldWidget(
                    controlObsecure: false,
                    hintText: 'Email',
                    txt: 'Your email',
                    onchange: (v) {
                      _email = v;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width / 25, vertical: size.height / 25),
                  child: LoginSignInTextFieldWidget(
                    controlObsecure: true,
                    hintText: 'Password',
                    txt: 'Password',
                    onchange: (v) {
                      _pass = v;
                    },
                  ),
                ),
                InkWell(
                    onTap: () async {
                      if (_email.isNotEmpty &&
                          _pass.isNotEmpty &&
                          _name.isNotEmpty) {
                        if (image == null) {
                          showMyDialog(context, size,
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
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: size.width / 25,
                        right: size.width / 25,
                      ),
                      child: SizedBox(
                          width: size.width,
                          height: size.height / 13,
                          child: const LoginSigninButtonWidget(
                            iconControl: false,
                            iconUrl: '',
                            txt: 'Sign in',
                          )),
                    )),
                Padding(
                  padding: EdgeInsets.only(top: size.height / 45),
                  child: buildAccountButton(size),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: size.width / 50,
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        viewControl = 0;
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buildAccountButton(Size size) {
    return Row(
      children: [
        const Spacer(),
        Padding(
          padding: EdgeInsets.only(right: size.width / 40),
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
            child: SizedBox(
                width: size.width / 2.5,
                height: size.height / 13,
                child: const LoginSigninButtonWidget(
                  iconControl: true,
                  iconUrl: 'assets/icons/google.png',
                  txt: '',
                )),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: size.width / 40),
          child: SizedBox(
              width: size.width / 2.5,
              height: size.height / 13,
              child: const LoginSigninButtonWidget(
                txt: '',
                iconControl: true,
                iconUrl: 'assets/icons/apple.png',
              )),
        ),
        const Spacer(),
      ],
    );
  }

  SafeArea fogetPassScreen(Size size) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Text(
            'Forgot Password',
            style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.grey,
                fontSize: size.width / 25),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [],
      ),
    ));
  }

  //functions
  Future<void> loginFunction(String email, String pass) async {
    lottieProgressDialog(context, 'assets/json/progress.json');
    bool res = await Auth().loginUser(email, pass, context);
    if (context.mounted) {
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
    lottieProgressDialog(context, 'assets/json/progress.json');
    bool res = await Auth().signupUser(_email, _name, _pass, context, image);
    if (context.mounted) {
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
