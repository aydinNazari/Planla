import 'package:flutter/material.dart';
import 'package:planla/controls/providersClass/provider_user.dart';
import 'package:provider/provider.dart';
import '../utiles/constr.dart';
import '../widgets/profile_img_widget.dart';
import '../widgets/textField/textinputfield_widget.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ProviderUser providerUser =
        Provider.of<ProviderUser>(context, listen: true);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                        Color(0xff46829b),
                        Color(0xff544797),
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
              child:
                  buildTextAndTextField(size, 'Bio', 'Enter your bio', 'Bio'),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height / 25),
              child: buildTextAndTextField(
                  size, 'Name', providerUser.user.name, 'Name'),
            ),
          ],
        ),
      ),
    );
  }

  Row buildTextAndTextField(Size size, String txt, String hint, String label) {
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
              onchange: (v) {},
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
