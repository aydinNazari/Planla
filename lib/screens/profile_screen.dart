import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:planla/controls/firebase/auth.dart';
import 'package:planla/controls/providersClass/provider_user.dart';
import 'package:planla/screens/login_signin_screen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<ProviderUser>(context, listen: false);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              user.user.username,
              style: const TextStyle(
                color: Colors.black
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                  onPressed: () async {
                    await Auth().signOut();
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.topToBottom,
                        child: LoginSignInScreen(),
                      ),
                    );
                  },
                  child: const Text('LogOut')),
            )
          ],
        ),
      ),
    );
  }
}
