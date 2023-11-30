import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:planla/controls/providersClass/provider_user.dart';
import 'package:planla/utiles/constr.dart';
import 'package:provider/provider.dart';

class NavigatorScreen extends StatefulWidget {
  const NavigatorScreen({Key? key}) : super(key: key);

  @override
  State<NavigatorScreen> createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  int currentIndex = 0;

  void navigatorIndex(int value) {
    setState(() {
      currentIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final user = Provider.of<ProviderUser>(context, listen: false);
    return Scaffold(
      body: screenList[currentIndex],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(size.width / 45),
        child: Container(
          width: size.width,
          height: size.height / 11,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
            Radius.circular(
              size.width / 20,
            ),
          )),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (v) {
              navigatorIndex(v);
            },
            items: [
              BottomNavigationBarItem(
                backgroundColor: Colors.black,
                icon: Icon(
                  Icons.home_outlined,
                  size: size.width / 17,
                  color: Colors.white,
                ),
                activeIcon: Icon(
                  Icons.home,
                  size: size.width / 14,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.add_outlined,
                  size: size.width / 17,
                ),
                activeIcon: Icon(
                  Icons.add,
                  size: size.width / 14,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.analytics_outlined,
                  size: size.width / 17,
                ),
                activeIcon: Icon(
                  Icons.analytics,
                  size: size.width / 14,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: /*Icon(
                  Icons.person_outline,
                  size: size.width / 17,
                )*/
                    SizedBox(
                  width: size.width / 17,
                  height: size.width / 17,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(size.width / 2),
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
                activeIcon: /*Icon(
                  Icons.person,
                  size: size.width / 14,
                ),*/
                    /*  Container(
                  width: size.width / 14,
                  height: size.width / 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: user.user.imageurl.isEmpty ?
                      const AssetImage('assets/icons/person_icon.png') :
                      NetworkImage(user.user.imageurl) as ImageProvider<Object>,
                    ),
                  ),
                ),*/
                    SizedBox(
                  width: size.width / 17,
                  height: size.width / 17,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(size.width / 2),
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
                /*CachedNetworkImage(
       imageUrl: "http://via.placeholder.com/350x150",
       progressIndicatorBuilder: (context, url, downloadProgress) =>
               CircularProgressIndicator(value: downloadProgress.progress),
       errorWidget: (context, url, error) => Icon(Icons.error),
    ),
                */
                label: '',
              )
            ],
          ),
        ),
      ),
    );
  }
}
