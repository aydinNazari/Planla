import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planla/controls/providersClass/provider_user.dart';
import 'package:planla/models/today_model.dart';
import 'package:planla/utiles/constr.dart';
import 'package:planla/widgets/addpage_card_widget.dart';
import 'package:provider/provider.dart';
import 'package:planla/models/user.dart' as model;

import '../controls/firebase/firestore._methods.dart';
import '../widgets/add_textfield_widget.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  late TodayModel todayModel;
  var selectedValue='';
  List<TodayModel> todayList = [];

 // String value = '';

  String txt = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    todayList.clear();
    getFirestore();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = Provider.of<ProviderUser>(context, listen: false).user;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: size.width / 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height / 25,
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: size.width,
                    child: AddTextfieldWidget(
                        onSubmit: (value) async {
                      txt = value;
                      value = '';
                      if(txt.isNotEmpty){
                        DateTime dateTime = DateTime.now();
                        // DateTime'i Timestamp'e çevirir
                        Timestamp timestamp = Timestamp.fromDate(dateTime);
                        todayModel = TodayModel(
                            text: txt,
                            dateTime: timestamp,
                            done: false,
                            important: false,
                            typeWork: selectedValue,
                        email: user.email,
                          uid: user.uid
                        );
                        bool res = await FirestoreMethods()
                            .firestoreUpload(context, user, todayModel);
                        if (res) {
                          updateFirestore();
                          getFirestore();
                        }
                      }else{
                        showSnackBar(context,'Fill in all fields', Colors.red);
                      }
                    }),
                  ),
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     /*DropdownAddpageWidget(onChange: (value){

                       setState(() {
                         selectedValue = value!;
                       });
                    }, selectedValue: selectedValue),*/
                    Padding(
                      padding: EdgeInsets.only(top: size.height / 30),
                      child: InkWell(
                        onTap: () async {
                          if (txt.isNotEmpty) {

                            DateTime dateTime = DateTime.now();
                            // DateTime'i Timestamp'e çevir
                            Timestamp timestamp = Timestamp.fromDate(dateTime);

                            todayModel = TodayModel(
                                text: txt,
                                dateTime: timestamp,
                                done: false,
                                important: false,
                                typeWork: selectedValue,
                            email: user.email,
                              uid: user.uid
                            );
                            bool res = await FirestoreMethods()
                                .firestoreUpload(context, user, todayModel);
                            if (res) {
                              updateFirestore();
                              getFirestore();
                            }
                          } else {
                            setState(() {
                              showSnackBar(
                                  context, 'Fill in all fields', Colors.red);
                            });
                          }
                        },
                        child: Container(
                          width: size.width / 4,
                          height: size.height / 13,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(size.width / 50))),
                          child: Center(
                              child: Text(
                            'Add',
                            style: TextStyle(
                                color: Colors.white, fontSize: size.width / 24),
                          )),
                        ),
                      ),
                    )
                  ],
                ))
              ],
            ),
            //DropdownAddpageWidget(),
            //const AddPageCardWidget(),
            Expanded(
              child: ListView.builder(
                  itemCount: todayList.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {},
                        child: AddPageCardWidget(
                          todayModel: todayList[index],
                        ));
                  }),
            )
          ],
        ),
      ),
    );
  }

  Future<void> getFirestore() async {
    bool res = await FirestoreMethods().getFiresoreData(context);
    if (res) {
      setState(() {
        todayList = Provider.of<ProviderUser>(context, listen: false).todayList;
      });
    }
  }
  Future<void> updateFirestore()async{
    bool updateControl= await FirestoreMethods().updateUser(context);
  }
}
