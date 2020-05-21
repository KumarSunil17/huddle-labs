import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ProjectDetailsPage extends StatelessWidget {
  final String projectId;
  const ProjectDetailsPage(this.projectId);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PieChart(
          PieChartData(
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 0,
              centerSpaceRadius: 40,
              sections: List.generate(4, (i) {
                switch (i) {
                  case 0:
                    return PieChartSectionData(
                      color: const Color(0xff0293ee),
                      value: 40,
                      title: '40%',
                      radius: 50,
                      titleStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xffffffff)),
                    );
                  case 1:
                    return PieChartSectionData(
                      color: const Color(0xfff8b250),
                      value: 30,
                      title: '30%',
                      radius: 50,
                      titleStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xffffffff)),
                    );
                  case 2:
                    return PieChartSectionData(
                      color: const Color(0xff845bef),
                      value: 15,
                      title: '15%',
                      radius: 50,
                      titleStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xffffffff)),
                    );
                  case 3:
                    return PieChartSectionData(
                      color: const Color(0xff13d38e),
                      value: 15,
                      title: '15%',
                      radius: 50,
                      titleStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xffffffff)),
                    );
                  default:
                    return null;
                }
              })),
        ),
      ),
    );
  }
}
