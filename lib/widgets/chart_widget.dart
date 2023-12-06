import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartWidget extends StatelessWidget {
  const ChartWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width / 1.1,
      height: size.height / 3,
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
        child: PieChart(PieChartData(
            centerSpaceColor: Colors.black26,
            centerSpaceRadius: 5,
            borderData: FlBorderData(show: false),
            sectionsSpace: 2,
            sections: [
              PieChartSectionData(
                value: 20,
                color: const Color(0xff424874),
                title: 'Sport',
                titleStyle: const TextStyle(color: Colors.white),
                radius: size.width / 4,
              ),
              PieChartSectionData(
                title: 'Study',
                value: 80,
                color: const Color(0xffdcd6f7),
                radius: size.width / 4,
              ),
              PieChartSectionData(
                title: 'Work',
                value: 30,
                color: const Color(0xffa6b1e1),
                radius: size.width / 4,
              ),
              PieChartSectionData(
                title: 'Other',
                value: 30,
                color: const Color(0xff8591c5),
                radius: size.width / 4,
              ),
            ])),
      ),
    );
  }
}
