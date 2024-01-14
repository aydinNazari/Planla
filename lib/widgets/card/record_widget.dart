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
          borderRadius: BorderRadius.all(
              Radius.circular(size.width / 15))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Your Record',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: size.width / 15,
              shadows: const <Shadow>[
                Shadow(
                    color: Colors.white,
                    blurRadius: 3,
                    offset: Offset(0, 0))
              ],
            ),
          ),
          Text(
            '${providerUser.getScore}h',
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