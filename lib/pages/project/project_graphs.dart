import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ProjectTaskGraph extends StatefulWidget {
  final Map<String, double> graphData;
  const ProjectTaskGraph(this.graphData);

  @override
  _ProjectTaskGraphState createState() => _ProjectTaskGraphState();
}

class _ProjectTaskGraphState extends State<ProjectTaskGraph> {
  int touchedIndex;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 240,
      child: PieChart(PieChartData(
          pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
            setState(() {
              if (pieTouchResponse.touchInput is FlLongPressEnd ||
                  pieTouchResponse.touchInput is FlPanEnd) {
                touchedIndex = -1;
              } else {
                touchedIndex = pieTouchResponse.touchedSectionIndex;
              }
            });
          }),
          borderData: FlBorderData(
            show: false,
          ),
          sectionsSpace: 0,
          centerSpaceRadius: 30,
          sections: widget.graphData.keys.map((data) {
            final isTouched =
                widget.graphData.keys.toList().indexOf(data) == touchedIndex;
            final double fontSize = isTouched ? 20 : 16;
            final double radius = isTouched ? 90 : 80;

            return PieChartSectionData(
              color: getColor(widget.graphData.keys.toList().indexOf(data)),
              value: widget.graphData[data],
              title: '$data\n${widget.graphData[data]}',
              radius: radius,
              titleStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffffffff)),
            );
          }).toList())),
    );
  }

  Color getColor(int i) {
    switch (i) {
      case 0:
        return Color(0xffEC6B56);
      case 1:
        return Color(0xffFFC154);
      case 2:
        return Color(0xff47B39C);

      default:
        return Color(0xffEC6B56);
    }
  }
}

class ProjectUsersGraph extends StatefulWidget {
  final Map<String, double> graphData;
  const ProjectUsersGraph(this.graphData);

  @override
  _ProjectUsersGraphState createState() => _ProjectUsersGraphState();
}

class _ProjectUsersGraphState extends State<ProjectUsersGraph> {
  int touchedIndex;
  List<Color> colors;

  @override
  void initState() {
    super.initState();
    colors = widget.graphData.keys
        .toList()
        .map((e) => UniqueColorGenerator.getColor())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 240,
      child: PieChart(PieChartData(
          pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
            setState(() {
              if (pieTouchResponse.touchInput is FlLongPressEnd ||
                  pieTouchResponse.touchInput is FlPanEnd) {
                touchedIndex = -1;
              } else {
                touchedIndex = pieTouchResponse.touchedSectionIndex;
              }
            });
          }),
          borderData: FlBorderData(
            show: false,
          ),
          sectionsSpace: 0,
          centerSpaceRadius: 30,
          sections: widget.graphData.keys.map((data) {
            final isTouched =
                widget.graphData.keys.toList().indexOf(data) == touchedIndex;
            final double fontSize = isTouched ? 20 : 14;
            final double radius = isTouched ? 90 : 80;

            return PieChartSectionData(
              color: colors[widget.graphData.keys.toList().indexOf(data)],
              value: widget.graphData[data],
              title: '$data\n${widget.graphData[data]}',
              radius: radius,
              titleStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xffffffff)),
            );
          }).toList())),
    );
  }
}

class UniqueColorGenerator {
  static Random random = Random();
  static Color getColor() {
    return Color.fromARGB(255, random.nextInt(255), random.nextInt(255), 80);
  }
}
