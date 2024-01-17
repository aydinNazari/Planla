import 'package:flutter/material.dart';
import 'package:planla/controls/firebase/firestore._methods.dart';
import 'package:planla/controls/providersClass/provider_user.dart';
import 'package:provider/provider.dart';
import '../utiles/constr.dart';
import '../widgets/profile_img_widget.dart';
import '../widgets/textField/textinputfield_widget.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({Key? key}) : super(key: key);

   String name='';
   String bio='';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ProviderUser providerUser =
        Provider.of<ProviderUser>(context, listen: true);
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
                      logOutFunc(context, size, true, providerUser);
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
                        child: Text(
                          'Setting',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: size.width / 14,
                              fontWeight: FontWeight.w700),
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
                  'Bio',
                  providerUser.user.bio != ''
                      ? providerUser.user.bio
                      : 'Enter your bio',
                  'Bio', (v) {
                bio = v;
              }),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height / 25),
              child: buildTextAndTextField(
                  size, 'Name', providerUser.user.name, 'Name', (v) {
                name = v;
              }),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height / 8),
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
                    if (name.isNotEmpty || bio.isNotEmpty) {
                      lottieProgressDialog(context, 'assets/json/loading.json');
                      await FirestoreMethods()
                          .updateUserElements(context, bio, name);
                      if (context.mounted) {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      }
                    } else {
                      showSnackBar(
                          context, 'You did not enter anything ', Colors.red);
                    }
                  },
                  child: Text(
                    'Update',
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
                  fontSize: size.width / 20,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ),
        Expanded(
          flex: 7,
          child: Padding(
            padding:
                EdgeInsets.only(left: size.width / 25, right: size.width / 25),
            child: TextInputField(
              onSubmited: (v){

              },
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
