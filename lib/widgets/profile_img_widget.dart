import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class ProgileImgWidget extends StatelessWidget {
  final String url;
  const ProgileImgWidget({Key? key, required this.url}) : super(key: key);

  //type==0 for navigator
  //type==1 for homepage
  //type==2 for profile


  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    //final user=Provider.of<ProviderUser>(context,listen: false);
    return ClipRRect(
      borderRadius:
      BorderRadius.circular(size.width / 2),
      child: /*user.user.imageurl.isEmpty*/url == ''
          ? Image.asset('assets/icons/person_icon.png')
          : CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        progressIndicatorBuilder:
            (context, url, downloadProgress) =>
            CircularProgressIndicator(
                value: downloadProgress.progress),
        errorWidget: (context, url, error) {
          if (kDebugMode) {
            print(error.toString());
          }
          return Icon(
            CupertinoIcons.person,
            color: Colors.black,
            size: size.width / 4,
          );
        },
      ),
    );
  }
}
