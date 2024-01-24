import 'package:flutter/material.dart';

import '../../controls/providersClass/provider_user.dart';

class RecordWidget extends StatelessWidget {
  const RecordWidget({
    super.key,
    required this.size,
    required this.providerUser,
  });

  final Size size;
  final ProviderUser providerUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xff4855e5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 0),
            ) // changes position of shadow),
          ],

          /*gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xff4855e4),
              Color(0xff83a3b2),
            ],
          ),*/
          borderRadius: BorderRadius.all(Radius.circular(size.width / 15))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            providerUser.getLanguage ? 'Rekorunuz' : 'Your Record',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: size.width / 15,
              shadows: const <Shadow>[
                Shadow(color: Colors.white, blurRadius: 3, offset: Offset(0, 0))
              ],
            ),
          ),
          Text(
            providerUser.getLanguage
                ? '${providerUser.getScore}s'
                : '${providerUser.getScore}h',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
              fontSize: size.width / 15,
              shadows: const <Shadow>[
                Shadow(
                  color: Colors.white70,
                  blurRadius: 2,
                  offset: Offset(0, 0),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
