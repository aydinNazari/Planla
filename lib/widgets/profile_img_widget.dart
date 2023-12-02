import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planla/controls/providersClass/provider_user.dart';
import 'package:provider/provider.dart';

class ProgileImgWidget extends StatelessWidget {
  final int type;
  const ProgileImgWidget({Key? key, required this.type}) : super(key: key);

  //type==0 for navigator
  //type==1 for homepage
  //type==2 for profile


  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    final user=Provider.of<ProviderUser>(context,listen: false);
    return SizedBox(
      width:type ==2 ? size.width / 3.5 : type == 0 ? size.width/17 : size.width/8 ,
      height: type ==2 ? size.width / 3.5 : type == 0 ? size.width/17 : size.width/8 ,
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
              CupertinoIcons.person,
              size: size.width / 4,
            );
          },
        ),
      ),
    );
  }
}
