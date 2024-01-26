import 'package:flutter/material.dart';
import 'package:planla/controls/firebase/firestore._methods.dart';
import 'package:planla/controls/providersClass/provider_user.dart';
import 'package:provider/provider.dart';
import '../controls/providersClass/timer_provider.dart';
import '../utiles/constr.dart';
import '../widgets/profile_img_widget.dart';
import '../widgets/textField/textinputfield_widget.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String name = '';

  String bio = '';

  String valueLan = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ProviderUser providerUser =
        Provider.of<ProviderUser>(context, listen: true);
    TimerProvider timerProvider =
        Provider.of<TimerProvider>(context, listen: false);
    providerUser.user.language=='Tur' ? valueLan='Türkçe' : valueLan='English';
    if(valueLan == '') {
      valueLan='English';
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: size.width,
                  height: size.height / 2.5,
                ),
                Container(
                  width: size.width,
                  height: size.height / 3,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xff544797),
                        Color(0xff46829b),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: size.width / 25,
                  top: size.height / 20,
                  child: InkWell(
                    onTap: () {
                      logOutFunc(
                          context, size, true, providerUser, timerProvider);
                    },
                    child: Icon(Icons.logout,
                        color: Colors.white, size: size.width / 18),
                  ),
                ),
                Positioned(
                  left: size.width / 25,
                  top: size.height / 10,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white70,
                          size: size.width / 12,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: size.width / 55),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            providerUser.getLanguage ? 'Ayarlar' : 'Setting',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: size.width / 14,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    width: size.width / 3.5,
                    height: size.width / 3.5,
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: Center(
                      child: SizedBox(
                        width: size.width / 3.5,
                        height: size.width / 3.5,
                        child: GestureDetector(
                          onTap: () {
                            uploadOrRemoveProfilePhoto(
                                context, size, true, providerUser);
                          },
                          child: ProgileImgWidget(
                            url: providerUser.user.imageurl,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                /*bottom: size.height / 70,
                  right: 0,
                  left: 0,*/
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height / 25),
              child: buildTextAndTextField(
                  size,
                  providerUser.getLanguage ? 'Açıklama' : 'Bio',
                  providerUser.user.bio != ''
                      ? providerUser.user.bio
                      : (providerUser.getLanguage
                          ? 'Açıklamanızı ekleyin'
                          : 'Enter your bio'),
                  providerUser.getLanguage ? 'Bio' : 'Açıklama', (v) {
                bio = v;
              }),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height / 25),
              child: buildTextAndTextField(
                  size,
                  providerUser.getLanguage ? 'İsim' : 'Name',
                  providerUser.user.name,
                  providerUser.getLanguage ? 'İsim' : 'Name', (v) {
                name = v;
              }),
            ),
            SizedBox(
              height: size.height/20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding:  EdgeInsets.only(left: size.width/25),
                    child: Text(
                      providerUser.getLanguage ? 'Dil' : 'Language',
                      style: TextStyle(
                          color: const Color(0xff234565),
                          fontSize: size.width / 28,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Padding(
                    padding: EdgeInsets.only(left: size.width/15,right: size.width/15),
                    child: SizedBox(
                      width: size.width / 2,
                      height: size.height / 10,
                      child: DropdownButton(
                        alignment: Alignment.center,
                        dropdownColor: const Color(0xffc9cfd5),
                        icon: Padding(
                          padding: EdgeInsets.only(right: size.width/12),
                          child: const Icon(Icons.language),
                        ),
                        items: [
                          DropdownMenuItem<String>(
                            alignment: Alignment.center,
                            value: 'English',
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: size.width / 100),
                                  child: SizedBox(
                                      width: size.width / 12,
                                      child: Image.asset(
                                          'assets/images/uk-flag.png')),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: size.width / 25),
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
                                    child: Image.asset(
                                        'assets/images/turkey.png')),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: size.width / 25),
                                  child: const Text('Türkçe'),
                                ),
                              ],
                            ),
                          ),
                        ],
                        isExpanded: true,
                        value: valueLan ,
                        borderRadius:
                            BorderRadius.all(Radius.circular(size.width / 25)),
                        onChanged: (Object? value) async {
                          if (value is String) {
                            if (value == 'English') {
                              valueLan = value;
                            } else {
                              valueLan = value;
                            }
                          }
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height / 18),
              child: Container(
                width: size.width / 3,
                height: size.height / 12,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xff46829b),
                      Color(0xff544797),
                    ],
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(size.width / 25),
                  ),
                ),
                child: Center(
                    child: InkWell(
                  onTap: () async {
                    if (name.isNotEmpty || bio.isNotEmpty ) {
                      lottieProgressDialog(context, 'assets/json/loading.json');
                      await FirestoreMethods().updateUserElements(
                          context,
                          bio,
                          name,
                          true); //bunu değiştir dil ayarları ekle ve buna value yu ata
                      if (context.mounted) {
                        print('ghghhggggggggggggggg');
                        print(valueLan);
                        await FirestoreMethods().setLanguage(
                            context, valueLan=='Türkçe' ? 'Tur' : 'En');ffffff
                      }
                      if (valueLan == 'English') {
                        providerUser.setLanguage(false);
                      } else {
                        providerUser.setLanguage(true);
                      }
                      if (context.mounted) {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      }
                    } else {
                      showSnackBar(
                          context,
                          providerUser.getLanguage
                              ? 'Hiçbir şey girmedin'
                              : 'You did not enter anything ',
                          Colors.red);
                    }
                  },
                  child: Text(
                    providerUser.getLanguage ? 'Güncelle' : 'Update',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width / 20,
                        fontWeight: FontWeight.w600),
                  ),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }

  Row buildTextAndTextField(Size size, String txt, String hint, String label,
      void Function(String) func) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.only(left: size.width / 25),
            child: Text(
              txt,
              style: TextStyle(
                  color: const Color(0xff234565),
                  fontSize: size.width / 28,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ),
        Expanded(
          flex: 8,
          child: Padding(
            padding:
                EdgeInsets.only(left: size.width / 25, right: size.width / 25),
            child: TextInputField(
              onSubmited: (v) {},
              onchange: func,
              inputLenghtControl: false,
              hintText: hint,
              hintColor: Colors.grey,
              iconWidget: const SizedBox(),
              labelTextWidget: Text(label),
              obscrueText: false,
            ),
          ),
        )
        // buraya biosu var ise biosunu yaz
      ],
    );
  }
}
