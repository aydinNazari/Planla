import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:planla/controls/providersClass/timer_provider.dart';

import 'package:planla/screens/add_screen.dart';
import 'package:planla/screens/profile_screen.dart';
import 'package:planla/screens/timer_screen.dart';
import 'package:provider/provider.dart';
import 'package:planla/models/user.dart' as model;
import '../controls/firebase/auth.dart';
import '../controls/firebase/storage.dart';
import '../controls/providersClass/provider_user.dart';
import '../screens/home_screen.dart';
import '../screens/login_signin_screen.dart';

//navigator pages
List<Widget> screenList = [
  const HomeScreen(),
  const AddScreen(),
/*  const Center(
    child: Text('Analize'),
  ),*/
  const TimerScreen(),
  const ProfileScreen(
    control: false,
  ),
];

//dropdown items
final List<String> itemsEn = [
  'Study',
  'Work',
  'Sport',
  'other',
];
final List<String> itemsTur = [
  'Okumak',
  'Çalışmak',
  'Spor',
  'Diğer',
];

List<String> motivationSentencesEnList = [
  "Believe in yourself; you are capable of amazing things.",
  "Your only limit is you. Break through it.",
  "Every small step you take brings you closer to big achievements.",
  "Challenges are opportunities in disguise. Embrace them!",
  "Success is not final, failure is not fatal: It is the courage to continue that counts.",
  "Dream big, work hard, stay focused.",
  "The only way to do great work is to love what you do.",
  "Don't watch the clock; do what it does. Keep going.",
  "Your attitude determines your direction.",
  "The harder you work for something, the greater you'll feel when you achieve it.",
  "Success is not just about making money; it's about making a difference.",
  "You are never too old to set another goal or to dream a new dream.",
  "Obstacles are the cost of greatness.",
  "Don't be afraid to give up the good to go for the great.",
  "Every morning brings new potential, but only if you make the most of it.",
  "Your time is limited, don't waste it living someone else's life.",
  "The only way to predict the future is to create it.",
  "Your energy introduces you before you even speak.",
  "Don't stop until you're proud.",
  "Be the change you wish to see in the world."
];
List<String> motivationSentencesTurList = [
  "Başarı, sabır ve azimle bir araya gelir.",
  "Çalışmaktan asla vazgeçme, çünkü emek verdiğin her an, geleceğine bir adımdır.",
  "Yüksek dağları aşmanın tek yolu adım adım tırmanmaktır.",
  "Hedeflerine ulaşmak için bugün adım at, yarının başarısı bugünkü çabalarındadır.",
  "Engeller, başarı yolundaki sınavlardır; onları aşmak senin gücündedir.",
  "Azimli ol, çünkü başarıyı sadece isteyenler değil, çalışanlar elde eder.",
  "En büyük zaferler, en zorlu mücadelelerin ardından gelir.",
  "Çalışma isteğin, hedeflerine olan bağlılığını belirler.",
  "Bugünün küçük adımları, yarının büyük zaferlerine dönüşecektir.",
  "Başarı, bir gün istemekle değil, her gün çalışmakla gelir.",
  "Kendine inan, başkalarının seni motive etmesini bekleme.",
  "Her başarı, bir miktar fedakarlık ve kararlılık gerektirir.",
  "Başarı, engelleri aşmaktan vazgeçmeyenlerin elindedir.",
  "Zorluklar sadece gücünü test etmek içindir; sen de bu testi geçebilirsin.",
  "Hedeflerine ulaşmak için bugün attığın her adım, seni yarının başarılarına götürür.",
  "Çalışma, hayallerini gerçekleştirmek için atman gereken ilk adımdır.",
  "Başarı, istemekten çok, istikrarlı bir şekilde çalışmaktan gelir.",
  "Hedeflerini gerçekleştirmek için bir adım at, geriye bakma.",
  "Hayal et, inan, çalış ve başar.",
  "Hiçbir şey, kararlı bir irade ve sürekli çaba karşısında duramaz."
];
List<String> motivationLottieList = [
  'https://lottie.host/659b65a9-d50c-4a25-bbca-1dd14a8f0e60/uUWtrC4btf.json',
  'https://lottie.host/fef09369-1da0-4ccc-adc2-f13765c14f10/rTtMACeSU4.json',
  'https://lottie.host/a9e26b04-490c-406e-b86c-f67cba079316/w06joMa1us.json',
  'https://lottie.host/dbcb68e5-8933-458a-bf5a-1a7d6a3e95f0/GkzLdZODKh.json',
  'https://lottie.host/dc6293f1-b81a-411b-be0d-e21aea6d123c/dCUg2RsDp3.json',
  'https://lottie.host/bcf23d1b-f8a1-4a36-9f20-ad0ae797c192/abKBRRDsAF.json',
  'https://lottie.host/8ba0c1c4-be52-4520-907d-ad191820a723/BqIN1FnVUW.json',
  'https://lottie.host/5d61ae1e-8698-4fae-8e06-473a0451d130/ut3CkCCVEs.json',
  'https://lottie.host/91f29db3-777e-46b7-b435-e3812fa6796d/g5lilnuJjt.json',
  'https://lottie.host/e1441770-88f7-4a5a-97fd-0101904e2a21/kAk56s2QnJ.json',
  'https://lottie.host/50d8c47a-d68f-4179-97da-2608d6114550/ZWGGLyJNVB.json',
  'https://lottie.host/33b0de7a-55f3-4d37-80e0-674c2e53bda6/QGy6sekHDW.json'
];

//firebase instances
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseStorage firebaseStorage = FirebaseStorage.instance;

showSnackBar(BuildContext context, String txt, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        txt,
      ),
      backgroundColor: color,
      duration: const Duration(
        seconds: 2,
      ),
    ),
  );
}

//for picking photo
Future<Uint8List?> pickImager() async {
  FilePickerResult? pickedImage =
  await FilePicker.platform.pickFiles(type: FileType.image);
  if (kIsWeb) {
    return pickedImage?.files.single.bytes;
  }
  if (pickedImage != null) {
    return await File(pickedImage.files.single.path!).readAsBytes();
  }
  return null;
}

//dialog
Future<void> showMyDialog(bool exitControl,
    BuildContext context,
    Size size,
    String txt,
    bool profilePhoto,
    void Function() yesFunction,
    void Function() noFunction) async {
  //profilePhoto ? dosen't photo : logout photo
  return showDialog<void>(
    context: context,
    barrierDismissible: profilePhoto ? true : false,
    builder: (BuildContext context) {
      ProviderUser providerUser =
      Provider.of<ProviderUser>(context, listen: true);
      return AlertDialog(
        backgroundColor: Colors.white,
        content: SingleChildScrollView(
          child: ListBody(
            mainAxis: Axis.vertical,
            children: <Widget>[
              profilePhoto == false
                  ? Column(
                children: [
                  exitControl
                      ? SizedBox(
                    width: size.width / 6,
                    height: size.width / 6,
                    child: Lottie.network(
                        'https://lottie.host/04e1b122-3b8f-4f93-b9cf-ee49f47be838/Ebix9jy6jB.json'),
                  )
                      : SizedBox(
                    width: size.width / 6,
                    height: size.width / 6,
                    child: Image.asset(
                        'assets/images/goals_dialog.png'),
                  ),
                  SizedBox(
                    height: size.height / 50,
                  ),
                  Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: size.width / 25),
                    child: Text(txt),
                  ),
                ],
              )
                  : const SizedBox()
            ],
          ),
        ),
        actions: <Widget>[
          profilePhoto
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Spacer(),
                  InkWell(
                    onTap: () async {
                      var image = await pickImager();
                      if (context.mounted) {
                        lottieProgressDialog(
                            context, 'assets/json/loading.json');
                      }
                      String url = await Storage().uploadImageToStorage(
                          image, providerUser.user.uid);
                      model.User user = model.User(
                          uid: providerUser.user.uid,
                          email: providerUser.user.email,
                          name: providerUser.user.name,
                          imageurl: url,
                          score: providerUser.user.score,
                          bio: providerUser.user.bio,
                      language: providerUser.getLanguage ? 'Tur' : 'En'
                      );
                      providerUser.setUser(user);
                      await firestore
                          .collection('users')
                          .doc(providerUser.user.uid)
                          .update(user.toMap());
                      if (context.mounted) {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text( providerUser.getLanguage ? 'Fotoğraf yükle' :
                      'Upload Photo',
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: size.width / 20,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: size.height / 25),
                child: Row(
                  children: [
                    const Spacer(),
                    InkWell(
                      onTap: () async {
                        if (providerUser.user.imageurl != '') {
                          if (context.mounted) {
                            lottieProgressDialog(
                                context, 'assets/json/loading.json');
                          }
                          await Storage().deleteProfilePhoto(
                              context, providerUser.user.uid);
                          model.User user = model.User(
                              uid: providerUser.user.uid,
                              email: providerUser.user.email,
                              name: providerUser.user.name,
                              imageurl: '',
                              score: providerUser.user.score,
                              bio: providerUser.user.bio,
                              language: providerUser.getLanguage ? 'Tur' : 'En'
                          );
                          providerUser.setUser(user);
                          if (context.mounted) {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          }
                        } else {
                          Navigator.of(context).pop();
                          showSnackBar(
                              context, providerUser.getLanguage ? 'Profil resminiz yok zaten!' :
                              'You don\'t have a profile picture yet',
                              Colors.red);
                        }
                      },
                      child: Text( providerUser.getLanguage ? 'Profil fotğradfını sil' :
                        'Remove Photo',
                        style: TextStyle(
                            color: providerUser.user.imageurl == ''
                                ? const Color(0xff989191)
                                : Colors.red,
                            fontSize: size.width / 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ],
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: yesFunction,
                  child: Text( providerUser.getLanguage ? 'Evet' :
                    'Yes',
                    style: TextStyle(
                        color: Colors.black, fontSize: size.width / 25),
                  )),
              TextButton(
                  onPressed: noFunction,
                  child: Text(providerUser.getLanguage ? 'Hayır' :
                    'No',
                    style: TextStyle(
                        color: Colors.black, fontSize: size.width / 25),
                  )),
            ],
          )
        ],
      );
    },
  );
}

//progress lottie
void lottieProgressDialog(BuildContext context, String url) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return Center(
        child: SizedBox(
          width: MediaQuery
              .of(context)
              .size
              .width / 2.2,
          height: MediaQuery
              .of(context)
              .size
              .width / 2.2,
          child: Lottie.asset(url),
        ),
      );
    },
  );
}

Future<void> logOutFunc(BuildContext context, Size size, bool exitType,
    ProviderUser providerUser, TimerProvider timerProvider) async {
  // exittype==true -> logOut
  // exittype==false -> exit from app
  if (exitType) {
    showMyDialog(
        true,
        context,
        size,
        providerUser.getLanguage
            ? 'Oturumu kapatmak istediğinizden emin misiniz?'
            : 'Are you sure you want to log out?',
        false, () async {
      await Auth().signOut();
      if (context.mounted) {
        providerUser.setControlFirestore(true);
        providerUser.setDoneList([]);
        providerUser.setTodayList([]);
        providerUser.setTankList([]);
        providerUser.setIdList([]);
        providerUser.setEventsListString([]);
        providerUser.setEventsValueList([]);
        providerUser.setEventsListString([]);
        providerUser.setMapEvent({});
        timerProvider.reseteSvcore();
        providerUser.setScore(0.0);
        Navigator.of(context).pop();
        Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            type: PageTransitionType.topToBottom,
            child: const LoginSignInScreen(),
          ),
              (route) => route.isCurrent,
        );
      }
    }, () {
      Navigator.of(context).pop();
    });
  } else {
    showMyDialog(
        false,
        context,
        size,
        providerUser.getLanguage
            ? 'Uygulamadan çıkmak istediğinizden emin misiniz?'
            :
        'Are you sure you want to exit the application?',
        false, () {
      exit(0);
    }, () {
      Navigator.of(context).pop();
    });
  }
}

Future<void> uploadOrRemoveProfilePhoto(BuildContext context, Size size,
    bool uploadOrRemove, ProviderUser providerUser) async {
  // uploadOrRemove==true -> upload
  // uploadOrRemove==false -> Remove
  if (uploadOrRemove) {
    showMyDialog(
        false,
        context,
        size,
        '',
        true, () async {}, () {});
  } else {
    showMyDialog(
        false,
        context,
        size,
        providerUser.getLanguage
            ? 'Uygulamadan çıkmak istediğinizden emin misiniz?':
            'Are you sure you want to exit the application?',
        false, () {
      exit(0);
    }, () {
      Navigator.of(context).pop();
    });
  }
}

void connectionKontrol(BuildContext context) async {
  final connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    if (context.mounted) {
      showSnackBar(
          context, 'Please check your internet connection', Colors.red);
    }
    // I am not connected to any network.
  }
}
