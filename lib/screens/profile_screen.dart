import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:planla/controls/firebase/auth.dart';
import 'package:planla/controls/providersClass/provider_user.dart';
import 'package:planla/screens/login_signin_screen.dart';
import 'package:provider/provider.dart';

import '../utiles/constr.dart';
import '../widgets/profile_img_widget.dart';
import '../widgets/task_done_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<ProviderUser>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          actions: [
        Padding(
          padding: EdgeInsets.only(
            right: size.width / 25,
          ),
          child: InkWell(
            onTap: () {
              logOutFunc(context,size);
            },
            child: Icon(
              Icons.logout,
              size: size.width / 18,
              color: Colors.white70,
            ),
          ),
        ),
      ], automaticallyImplyLeading: false),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.only(left: size.width / 10),
                  child: Text(
                    user.user.username,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width / 14,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: size.width / 10),
                child: const ProgileImgWidget(type: 2),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              top: size.height / 25,
            ),
            child: Row(
              children: [
                const Spacer(),
                TasksCountWidget(size: size, txt: 'Done', count: '1000'),
                const Spacer(),
                TasksCountWidget(size: size, txt: 'Taks', count: '50'),
                const Spacer(),
                TasksCountWidget(size: size, txt: 'Plaka', count: '***'),
                const Spacer()
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> logOutFunc(BuildContext context,Size size) async {
    showMyDialog(context, size,'Are you sure you want to log out?', () async {
      await Auth().signOut();
      setState(() {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.topToBottom,
            child: const LoginSignInScreen(),
          ),
        );
      });
    }, () {
      Navigator.of(context).pop();
    });
  }
}


