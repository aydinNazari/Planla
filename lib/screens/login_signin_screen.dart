import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:planla/controls/firebase/auth.dart';
import 'package:planla/controls/providersClass/provider_user.dart';
import 'package:page_transition/page_transition.dart';
import 'package:planla/screens/navigator_screen.dart';
import 'package:planla/screens/select_language_screen.dart';
import 'package:planla/widgets/buttons/login_signin_button_widget.dart';
import 'package:provider/provider.dart';
import '../controls/providersClass/timer_provider.dart';
import '../utiles/colors.dart';
import '../utiles/constr.dart';
import '../widgets/textField/login_signin_textfield_widget.dart';
import '../widgets/textField/textinputfield_widget.dart';
import 'email_verfication_screen.dart';

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
    ProviderUser providerUser = Provider.of<ProviderUser>(context);
    return viewControl == 0
        ? loginScreen(size)
        : viewControl == 1
            ? signInScreen(size, providerUser)
            : fogetPassScreen(size, providerUser);
  }

//Login widget
  SafeArea loginScreen(Size size) {
    TimerProvider timerProvider =
        Provider.of<TimerProvider>(context, listen: false);
    ProviderUser providerUser =
        Provider.of<ProviderUser>(context, listen: false);
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          logOutFunc(context, size, false, providerUser, timerProvider);
          return false;
        },
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
                    providerUser.getLanguage ? 'Üye olun' : 'Sign up',
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    providerUser.getLanguage ? 'Giriş yap' : 'Log in',
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
                     // controlObsecure: false,
                      passControl: false,
                      hintText: 'Email', controlObsecure: false,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: size.height / 25),
                    child: LoginSignInTextFieldWidget(
                      onchange: (v) {
                        _pass = v;
                      },
                      txt: providerUser.getLanguage ? 'Şifre' : 'Password',
                      controlObsecure: true,
                      passControl: true,
                      hintText: 'Şifre',
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
                                providerUser.getLanguage
                                    ? 'Lütfen tüm boşlukları doldurunuz'
                                    : 'Please fill in all fields',
                                Colors.red,
                              );
                            });
                          }
                        },
                        child: SizedBox(
                            width: size.width,
                            height: size.height / 13,
                            child: LoginSigninButtonWidget(
                              iconControl: false,
                              iconUrl: '',
                              txt: providerUser.getLanguage
                                  ? 'Giriş yap'
                                  : 'Log in',
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
                                  text: providerUser.getLanguage
                                      ? 'Hesabın yok mu?'
                                      : 'Dont\'t have an account?',
                                  style: TextStyle(
                                    fontSize: size.width / 25,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black45,
                                  ),
                                ),
                                TextSpan(
                                  text: providerUser.getLanguage
                                      ? '  Oluştur'
                                      : '  Register',
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
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: size.height / 85),
                    child: InkWell(
                      onTap: () async {
                        // await Auth().forgetPass(context, providerUser);
                        viewControl = 2;
                        setState(() {});
                      },
                      child: Text(
                        providerUser.getLanguage
                            ? 'Şifrenizi mi unuttunuz?'
                            : 'Do you forget your password?',
                        style: TextStyle(
                            fontSize: size.width / 25,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                            decoration: TextDecoration.underline,
                            decorationStyle: TextDecorationStyle.solid),
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

//signIn widget
  Widget signInScreen(Size size, ProviderUser providerUser) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          viewControl=0;
        });
        return false;
      },
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
                  providerUser.getLanguage ? 'Giriş yap' : 'Log in',
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
                    passControl: false,
                    hintText: providerUser.getLanguage ? 'İsim' : 'Name',
                    txt: providerUser.getLanguage ? 'İsminiz' : 'Your Name',
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
                    passControl: false,
                    hintText: providerUser.getLanguage ? 'E-posta' : 'Email',
                    txt: providerUser.getLanguage ? 'E-postanız' : 'Your email',
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
                    passControl: true,
                    hintText: providerUser.getLanguage ? 'Şifre' : 'Password',
                    txt: providerUser.getLanguage ? 'Şisfre' : 'Password',
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
                          showMyDialog(
                              false,
                              context,
                              size,
                              providerUser.getLanguage
                                  ? 'Profil resmini yüklemeden devam edeceğinizden emin misiniz?'
                                  : 'Are you sure to proceed without uploading the profile picture?',
                              false, () async {
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
                              context,
                              providerUser.getLanguage
                                  ? 'Lütfen tüm alanları doldurunuz'
                                  : 'Please fill in all fields',
                              Colors.red);
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
                          child: LoginSigninButtonWidget(
                            iconControl: false,
                            iconUrl: '',
                            txt:
                                providerUser.getLanguage ? 'Üye ol' : 'Sign in',
                          )),
                    )),
                Padding(
                  padding: EdgeInsets.only(top: size.height / 45,left: size.width/25),
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
                            text: providerUser.getLanguage
                                ? 'Zaten hesabınız var mı?'
                                : 'Already have an account?',
                            style: TextStyle(
                              fontSize: size.width / 25,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: providerUser.getLanguage
                                ? '  Giriş yap'
                                : '  Login',
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
        InkWell(
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
              width: size.width/1.1,
              height: size.height / 13,
              child: const LoginSigninButtonWidget(
                iconControl: true,
                iconUrl: 'assets/icons/google.png',
                txt: '',
              )),
        ),
        /*Padding(
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
        const Spacer(),*/
      ],
    );
  }

  Widget fogetPassScreen(Size size, ProviderUser providerUser) {
    String forgetEmail = '';
    TimerProvider timerProvider =
    Provider.of<TimerProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          viewControl=0;
        });
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xffe8decb),
        appBar: AppBar(
      backgroundColor: const Color(0xffe8decb),
      automaticallyImplyLeading: false,
      title: InkWell(
        onTap: () {
          viewControl=0;
          setState(() {});
        },
        child: Icon(
          Icons.arrow_back,
          color: Colors.black,
          size: size.width / 15,
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: size.width / 25),
          child: Text(
            providerUser.getLanguage ? 'Şifremi unuttum' : 'Forgot Password',
            style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.black87,
                fontSize: size.width / 25),
          ),
        ),
      ],
        ),
        body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: size.height / 7,
          ),
          SizedBox(
            width: size.width,
            height: size.height / 3,
            child: Lottie.network(
                'https://lottie.host/ece47491-287d-4fe9-9bd2-e0f600b190eb/WwAqFpxUAN.json'),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: size.height / 20,
                right: size.width / 25,
                left: size.width / 25),
            child: TextInputField(
              autofocusControl: false,
              controlCaptalWord: false,
              onSubmited: (v) {},
              onchange: (v) {
                forgetEmail = v;
              },
              inputLenghtControl: false,
              hintText: providerUser.getLanguage
                  ? 'E-posta adresinizi giriniz'
                  : 'Enter your mail',
              hintColor: Colors.grey,
              iconWidget: const SizedBox(),
              labelTextWidget: Text(providerUser.getLanguage
                  ? 'Şifremi unuttum'
                  : 'Forget pass'),
              obscrueText: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: size.height / 25),
            child: InkWell(
              onTap: () async {
                await Auth().forgetPass(context, forgetEmail);
                viewControl = 0;
                setState(() {});
              },
              child: Container(
                width: size.width / 3,
                height: size.height / 12,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xff232321),
                      Color(0xff2d2d2b),
                    ],
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(size.width / 25),
                  ),
                ),
                child: Center(
                  child: Text(
                    providerUser.getLanguage ? 'Gönder' : 'Send',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width / 19,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
        ),
      ),
    );
  }

  Future<void> loginFunction(String email, String pass) async {
    ProviderUser providerUser=Provider.of<ProviderUser>(context,listen: false);
    lottieProgressDialog(context, 'assets/json/progress.json');
    bool res = await Auth().loginUser(email, pass, context);
    if (context.mounted) {
      Navigator.of(context).pop();
    }


    if (res && context.mounted) {
     /* print('eeeeeeeeeeeeeeeeeeeeeeeeerrrrr');
      print(providerUser.user.email);
      print(providerUser.user.language);
      print(providerUser.getLanguage);
      print('rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrt');*/

      if(providerUser.user.language == ''){
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.bottomToTop,
            child: const SelectLanguageScreen(),
          ),
        );
      }else{
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.bottomToTop,
            child: const NavigatorScreen(),
          ),
        );
      }
    } else {
      if (context.mounted) {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.bottomToTop,
            child: const LoginSignInScreen(),
          ),
        );
      }
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
                type: PageTransitionType.leftToRight,
                child: const EmailVerfication()));
      });
    }
  }
}
