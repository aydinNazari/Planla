import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../utiles/constr.dart';
import '../widgets/textinputfield_widget.dart';

class LoginSignInScreen extends StatefulWidget {
  const LoginSignInScreen({Key? key}) : super(key: key);

  @override
  State<LoginSignInScreen> createState() => _LoginSignInScreenState();
}

class _LoginSignInScreenState extends State<LoginSignInScreen> {
  String _email = '';
  String _pass = '';
  String _username = '';
  bool viewControl = true;
  Uint8List? image;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return viewControl ? loginScreen(size) : signInScreen(size);
  }
  SafeArea signInScreen(Size size) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: size.height/20),
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
                      'Planla',
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
                    child:image == null ?
                    Stack(
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
                    ) : Container(
                      width: size.width / 3,
                      height: size.width / 3,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: Image.memory(
                        image!,
                        fit: BoxFit.cover,
                      ),
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: size.height / 50,
                    ),
                    child: TextInputField(
                      hintColor: Colors.black,
                      hintText: 'Enter your username please...',
                      iconWidget: Padding(
                        padding: EdgeInsets.only(right: size.width / 25),
                        child: const Icon(Icons.person),
                      ),
                      labelTextWidget: const Text('Username'),
                      obscrueText: false,
                      onchange: (String s) {
                        _username = s;
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
                      bottom: size.height / 25,
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
                    /*onTap: () => authController.registerUser(
                        _username, _email, _pass, authController.profilePhoto),*/
                    child: Container(
                      width: size.width / 1.1,
                      height: size.height / 13,
                      decoration: const BoxDecoration(
                        color: Color(0xff673031),
                      ),
                      child: Center(
                        child: Text(
                          'Sign in',
                          style: TextStyle(
                            fontSize: size.width / 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
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
                          viewControl = true;
                        });
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Already have an account?',
                              style: TextStyle(
                                fontSize: size.width / 22,
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

  SafeArea loginScreen(Size size) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height / 5,
              ),
              Center(
                child: Text(
                  'Planla',
                  style: TextStyle(
                      fontSize: size.width / 9,
                      fontWeight: FontWeight.w900,
                      color: Colors.black),
                ),
              ),
              Center(
                child: Text(
                  'Login',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width / 18,
                      fontWeight: FontWeight.w800),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: size.height / 25,
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
                    top: size.height / 25, bottom: size.height / 25),
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
                //onTap: () => authController.loginUser(_email, _pass),
                child: Container(
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
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'Dont\'t have an account?',
                          style: TextStyle(
                            fontSize: size.width / 22,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: '  Register',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: size.width / 22,
                            color: const Color(0xff673031),
                          ),
                        )
                      ])),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
