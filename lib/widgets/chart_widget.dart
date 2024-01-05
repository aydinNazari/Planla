import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:planla/controls/providersClass/provider_user.dart';
import 'package:provider/provider.dart';

import '../utiles/colors.dart';

class ChartWidget extends StatelessWidget {
  const ChartWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ProviderUser providerUser =
        Provider.of<ProviderUser>(context, listen: false);
    var size = MediaQuery.of(context).size;
    return SizedBox(
        width: size.width,
        height: size.height / 2.5,
        /*decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.13)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.15),
              Colors.white.withOpacity(0.5),
            ],
          ),
          borderRadius:
          BorderRadius.all(Radius.circular(size.width / 15))),*/
        child: Center(
          child: providerUser.getEventsString.isNotEmpty
              ? PieChart(
                  PieChartData(
                    centerSpaceColor: Colors.black26,
                    centerSpaceRadius: 5,
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 2,
                    sections: List.generate(
                      providerUser.getEventsString.length,
                      (index) => PieChartSectionData(
                        showTitle: true,
                        title: providerUser.getEventsString[index],
                        value: /*providerUser.getEventsListMap[1][providerUser.getEventsString] ??*/
                            55,
                        color: /*chartData[index]['color']*/ colorList[index],
                        titleStyle: TextStyle(
                            color: Colors.white, fontSize: size.width / 40),
                        radius: size.width / 4,
                      ),
                    ),
                  ),
                )
              : Column(
                  children: [
                    SizedBox(
                        width: size.width,
                        height: size.height / 3.5,
                        child: Lottie.network(
                            'https://lottie.host/c05bda17-1f57-47ad-8675-3b89edb4545d/uPwH4O4khz.json')),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width / 6),
                      child: Text(
                        'I can\'t create your chart because you don\'t have any activity!',
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: size.width / 25,
                            fontWeight: FontWeight.w700),
                      ),
                    )
                  ],
                ),
        ));
  }
}
