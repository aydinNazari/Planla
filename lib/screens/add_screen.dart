import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:planla/controls/providersClass/provider_user.dart';
import 'package:planla/models/today_model.dart';
import 'package:planla/widgets/addpage_card_widget.dart';
import 'package:provider/provider.dart';

import '../controls/firebase/firestore._methods.dart';
import '../utiles/colors.dart';
import '../widgets/add_textfield_widget.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {

  String txt = '';
  late TodayModel todayModel;

  List<TodayModel> todayList = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user=Provider.of<ProviderUser>(context,listen: false).user;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: size.width / 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height / 25,
              ),
              AddTextfieldWidget(onSubmit: (value) async {
                txt = value;
                todayModel = TodayModel(
                    text: txt,
                    dateTime: DateTime.now(),
                    done: false,
                    important: true,
                    typeWork: '');

                value='';
                bool res= await FirestoreMethods().firestoreUpload(context, user, todayModel);
                if(res){
                  print(res);
                  print('okkkkkkkkkkkkkk');
                  todayList.add(todayModel);
                }
                setState(() {});

              }),
             //const AddPageCardWidget(),
              ListView.builder(
                  itemCount: todayList.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context,index){
                return InkWell(
                    onTap: (){

                    },
                    child: AddPageCardWidget(todayModel: todayList[index],));
              })
            ],
          ),
        ),
      ),
    );
  }
}
