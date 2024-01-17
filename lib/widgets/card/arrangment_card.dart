import 'package:flutter/material.dart';

import '../profile_img_widget.dart';

class ArrangementCard extends StatelessWidget {
  const ArrangementCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          itemCount: 3,
          itemBuilder: (context, index) {
            return Padding(
              padding:
                  EdgeInsets.only(left: size.width / 25, top: size.height / 45),
              child: buildWidgetCard(size),
            );
          }),
    );
  }

  Row buildWidgetCard(Size size) {
    return Row(
      children: [
        SizedBox(
          width: size.width / 17,
          height: size.width / 17,
          child: const ProgileImgWidget(
            url: '',
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: size.width / 45),
          child: Text(
            'Kullanıcı ismi',
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
            '55h',
            style: TextStyle(
                color: const Color(0xff442342), fontSize: size.width / 20,fontWeight: FontWeight.w900),
          ),
        )
      ],
    );
  }
}
