import 'package:flutter/material.dart';
import 'package:planla/controls/providersClass/provider_user.dart';
import 'package:planla/utiles/colors.dart';
import 'package:provider/provider.dart';

import '../utiles/constr.dart';
import '../widgets/profile_img_widget.dart';
import '../widgets/task_done_widget.dart';

class ProfileScreen extends StatefulWidget {
  final bool control;

  //control ==true back arrow icon=true : back arrow icon=false
  const ProfileScreen({Key? key, required this.control}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<ProviderUser>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    userName = (user.user.email).substring(0, (user.user.email).indexOf('@'));
    return WillPopScope(
      onWillPop: () async {
        logOutFunc(context, size,false);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            widget.control
                ? Padding(
                    padding: EdgeInsets.only(left: size.width / 25),
                    child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: size.width / 16,
                        )),
                  )
                : const SizedBox(),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(
                right: size.width / 25,
              ),
              child: InkWell(
                onTap: () {
                  logOutFunc(context, size,true);
                },
                child: Icon(
                  Icons.logout,
                  size: size.width / 18,
                  color: Colors.black,
                ),
              ),
            ),
          ],
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: EdgeInsets.only(left: size.width / 10),
                    child: Column(
                      children: [
                        Text(
                          user.user.name,
                          style: TextStyle(
                              color: textColor,
                              fontSize: size.width / 14,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '@$userName',
                          style: TextStyle(
                              color: Colors.black38,
                              fontSize: size.width / 23,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
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
                  TasksCountWidget(
                      size: size,
                      txt: 'Done',
                      count: (user.user.doneCount).toString()),
                  const Spacer(),
                  TasksCountWidget(
                      size: size,
                      txt: 'Task',
                      count: (user.user.taskCount).toString()),
                  const Spacer(),
                  TasksCountWidget(size: size, txt: 'Plaka', count: '***'),
                  const Spacer()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
