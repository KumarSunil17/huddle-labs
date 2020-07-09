import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ProjectTaskGraph extends StatefulWidget {
  final Map<String, double> graphData;
  final int totalTasks;
  const ProjectTaskGraph(this.graphData, this.totalTasks);

  @override
  _ProjectTaskGraphState createState() => _ProjectTaskGraphState();
}

class _ProjectTaskGraphState extends State<ProjectTaskGraph> {
  int touchedIndex;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            blurRadius: 4,
            color: Color(0xff00f2fe).withOpacity(0.3),
            spreadRadius: 1,
            offset: Offset(0, 2))
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 200,
            width: 200,
            child: Stack(
              children: [
                PieChart(PieChartData(
                    pieTouchData:
                        PieTouchData(touchCallback: (pieTouchResponse) {
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
                          widget.graphData.keys.toList().indexOf(data) ==
                              touchedIndex;

                      final double fontSize = isTouched ? 18 : 16;

                      final double radius = isTouched ? 55 : 50;

                      return PieChartSectionData(
                        color: getColor(
                            widget.graphData.keys.toList().indexOf(data)),
                        value: widget.graphData[data],
                        title: '', //'/${widget.graphData[data]}\n$data',
                        showTitle: widget.graphData[data] != 0,
                        radius: radius,
                        titleStyle: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xffffffff)),
                      );
                    }).toList())),
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                              text: '${widget.totalTasks}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w800)),
                          TextSpan(
                            text: '\nTasks',
                          )
                        ]),
                  ),
                )
              ],
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.graphData.keys
                    .map(
                      (data) => Row(
                        children: [
                          AnimatedContainer(
                            duration: kThemeAnimationDuration,
                            width: touchedIndex ==
                                    widget.graphData.keys.toList().indexOf(data)
                                ? 38
                                : 32,
                            height: touchedIndex ==
                                    widget.graphData.keys.toList().indexOf(data)
                                ? 18
                                : 12,
                            color: getColor(
                                widget.graphData.keys.toList().indexOf(data)),
                          ),
                          SizedBox(width: 8),
                          Text(data),
                          SizedBox(width: 8),
                          Text(
                            '${widget.graphData[data]}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    )
                    .toList()),
          ),
        ],
      ),
    );
  }

  Color getColor(int i) {
    switch (i) {
      case 0:
        return Color(0xff540d6e);
      case 1:
        return Color(0xffee4266);
      case 2:
        return Color(0xffffd23f);
      case 3:
        return Color(0xff3bceac);
      default:
        return Color(0xffEC6B56);
    }
  }
}

// final List<Color> gradientColors = [
//   const Color(0xff4facfe),
//   const Color(0xff00f2fe),
// ];

class ProjectUsersGraph extends StatefulWidget {
  final Map<String, int> graphData;
  const ProjectUsersGraph(this.graphData);

  @override
  _ProjectUsersGraphState createState() => _ProjectUsersGraphState();
}

class _ProjectUsersGraphState extends State<ProjectUsersGraph> {
  int touchedIndex;

  @override
  Widget build(BuildContext context) {
    final List<GraphData> list = [];
    widget.graphData.keys.forEach((element) {
      list.add(GraphData(element, widget.graphData[element]));
    });
    return Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              blurRadius: 4,
              color: Color(0xff00f2fe).withOpacity(0.3),
              spreadRadius: 1,
              offset: Offset(0, 2))
        ]),
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(right: 46, left: 4, top: 22),
            child: BarChart(BarChartData(
              minY: 0,
              maxY: list.map((e) => e.value).reduce(max).toDouble(),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Colors.transparent,
                  tooltipPadding: const EdgeInsets.all(0),
                  tooltipBottomMargin: 0,
                  getTooltipItem: (
                    BarChartGroupData group,
                    int groupIndex,
                    BarChartRodData rod,
                    int rodIndex,
                  ) {
                    return BarTooltipItem(
                      rod.y.round().toString(),
                      TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: SideTitles(
                  showTitles: true,
                  textStyle: TextStyle(
                      color: Colors.black,
                      // fontWeight: FontWeight.bold,
                      fontSize: 14),
                  margin: 20,
                  getTitles: (double value) {
                    if (list[value.toInt()].name.length > 10)
                      return list[value.toInt()].name.substring(0, 10) + '...';
                    return list[value.toInt()].name;
                  },
                ),
                leftTitles: SideTitles(
                  showTitles: true,
                  textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  interval: list.map((e) => e.value).reduce(max) <= 1
                      ? 1
                      : (list.map((e) => e.value).reduce(max).toDouble() / 3)
                          .roundToDouble(),
                  reservedSize: 28,
                  margin: 12,
                ),
              ),
              borderData: FlBorderData(
                show: false,
              ),
              barGroups: list
                  .map((e) => BarChartGroupData(
                        x: list.indexOf(e),
                        barsSpace: 12,
                        barRods: [
                          BarChartRodData(
                              y: e.value.toDouble(),
                              borderRadius: BorderRadius.circular(2),
                              width: 30,
                              color: Colors.lightBlueAccent),
                        ],
                        showingTooltipIndicators: const [0],
                      ))
                  .toList(),
            ))));
  }
}

class GraphData {
  final String name;
  final int value;

  GraphData(this.name, this.value);

  @override
  String toString() {
    return 'GraphData{date: $name, value: $value}';
  }

  @override
  bool operator ==(Object other) =>
      other is GraphData && name == other.name && value == other.value;

  @override
  int get hashCode => name.hashCode ^ value.hashCode;
}
