import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:planla/controls/firebase/auth.dart';
import 'package:planla/controls/providersClass/provider_user.dart';
import 'package:planla/screens/login_signin_screen.dart';
import 'package:provider/provider.dart';

import '../utiles/constr.dart';

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
      appBar: AppBar(actions: [
        Padding(
          padding: EdgeInsets.only(
            right: size.width / 25,
            top: size.height / 50,
          ),
          child: InkWell(
            onTap: () {
              logOutFunc(context,size);
            },
            child: Icon(
              Icons.logout,
              size: size.width / 18,
            ),
          ),
        ),
      ], automaticallyImplyLeading: false),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: EdgeInsets.only(left: size.width / 10),
                    child: Text(
                      user.user.username,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: size.width / 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: size.width / 10),
                  child: SizedBox(
                    width: size.width / 3.5,
                    height: size.width / 3.5,
                    child: ClipRRect(
                        borderRadius:
                        BorderRadius.circular(size.width / 2),
                      child: user.user.imageurl.isEmpty
                          ? Image.asset('assets/icons/person_icon.png')
                          : CachedNetworkImage(
                              imageUrl: user.user.imageurl,
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      CircularProgressIndicator(
                                          value: downloadProgress.progress),
                              errorWidget: (context, url, error) {
                                print(error.toString());
                                return Icon(
                                  Icons.person,
                                  size: size.width / 4,
                                );
                              },
                            ),
                    ),
                  ),
                ),
              ],
            ),
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

class TasksCountWidget extends StatelessWidget {
  final String txt;
  final String count;

  const TasksCountWidget({
    super.key,
    required this.size,
    required this.txt,
    required this.count,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          txt,
          style:
              TextStyle(fontWeight: FontWeight.w600, fontSize: size.width / 20),
        ),
        Text(
          count,
          style: TextStyle(fontSize: size.width / 25),
        ),
      ],
    );
  }
}
