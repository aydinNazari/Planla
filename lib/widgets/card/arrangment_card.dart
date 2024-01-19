import 'package:flutter/material.dart';
import 'package:planla/controls/providersClass/provider_user.dart';
import 'package:planla/models/arrangment_model.dart';
import 'package:provider/provider.dart';

import '../profile_img_widget.dart';

class ArrangementCard extends StatelessWidget {
   const ArrangementCard({Key? key}) : super(key: key);

   //Map<String,Arrangment> map={};
  @override
  Widget build(BuildContext context) {
    ProviderUser providerUser=Provider.of<ProviderUser>(context);
    //print('${providerUser.getMapArrangment['1']!.name} sssssssssssssssssssssss');
    //map= getData(providerUser);
 /*   Arrangment arrangment1=map['1']!;
    Arrangment arrangment2=map['2']!;
    Arrangment arrangment3=map['3']!;*/
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff7fec98),
        borderRadius: BorderRadius.all(
          Radius.circular(size.width / 15),
        ),
      ),
      child: ListView.builder(
          shrinkWrap: false,
          scrollDirection: Axis.vertical,
          itemCount: providerUser.getMapArrangment.length,
          itemBuilder: (context, index) {
            return Padding(
              padding:
                  EdgeInsets.only(left: size.width / 25, top: size.height / 45),
              child: buildWidgetCard(size,index+1,providerUser),
            );
          }),
    );
  }

  /*Map<String, Arrangment>getData(ProviderUser providerUser){
    return map =providerUser.getMapArrangment;
  }*/

  Widget buildWidgetCard(Size size,int index,ProviderUser providerUser){
    return Row(
      children: [
        SizedBox(
          width: size.width / 17,
          height: size.width / 17,
          child:  ProgileImgWidget(
            url: providerUser.getMapArrangment[index.toString()]?.imgUrl ?? '',
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: size.width / 45),
          child: Text(
            providerUser.getMapArrangment[index.toString()]?.name ?? '',
            style: TextStyle(
                fontSize: size.width / 22,
                fontWeight: FontWeight.w500,
                color: const Color(0xff334312)),
          ),
        ),
        const Spacer(),
        Padding(
          padding:  EdgeInsets.only(right: size.width/15),
          child: Text(
            ('${providerUser.getMapArrangment['$index']?.score}h').toString(),
            style: TextStyle(
                color: const Color(0xff442342), fontSize: size.width / 20,fontWeight: FontWeight.w900),
          ),
        )
      ],
    );
  }
}
