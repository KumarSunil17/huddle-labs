import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'index.dart';

class DashboardChart extends StatefulWidget {
  final List<Color> availableColors = [
    Colors.purpleAccent,
    Colors.yellow,
    Colors.lightBlue,
    Colors.orange,
    Colors.pink,
    Colors.redAccent,
  ];
  DashboardChart({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DashboardChartState();
}

class DashboardChartState extends State<DashboardChart> {
  final Color barBackgroundColor = Colors.transparent;
  final Duration animDuration = const Duration(milliseconds: 250);
  int _touchedIndex;
  bool _loading = false;

  bool get loading => _loading;

  set loading(bool value) {
    setState(() {
      _loading = value;
      if (_loading) {
        refreshState();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: 800,
      child: Stack(
        children: [
          Positioned.fill(bottom: 20,
            child: BarChart(
              _loading ? randomData() : mainBarData(),
              swapAnimationDuration: animDuration,
            ),
          ),
          if(!_loading)Positioned(
            bottom: 0,
            left: 46,
            right: 0,
            height: 50,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
                itemBuilder: (c, i) => Container(
                      height: 50,
                      width: 50.5,
                      color: Colors.orange,
                    ),
                separatorBuilder: (c, i) =>
                    Container(height: 50, width: 50),
                itemCount: 8),
          )
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.orangeAccent,
    double width = 50,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barsSpace: 10,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 0.25 : y,
          color: isTouched ? Colors.deepOrangeAccent : barColor,
          width: width,
          borderRadius: BorderRadius.circular(3),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 20,
            color: barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(8, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, 5, isTouched: i == _touchedIndex);
          case 1:
            return makeGroupData(1, 6.5, isTouched: i == _touchedIndex);
          case 2:
            return makeGroupData(2, 5, isTouched: i == _touchedIndex);
          case 3:
            return makeGroupData(3, 7.5, isTouched: i == _touchedIndex);
          case 4:
            return makeGroupData(4, 9, isTouched: i == _touchedIndex);
          case 5:
            return makeGroupData(5, 11.5, isTouched: i == _touchedIndex);
          case 6:
            return makeGroupData(6, 6.5, isTouched: i == _touchedIndex);
             case 7:
            return makeGroupData(7, 6.5, isTouched: i == _touchedIndex);
          default:
            return null;
        }
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.black54,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = 'Monday';
                  break;
                case 1:
                  weekDay = 'Tuesday';
                  break;
                case 2:
                  weekDay = 'Wednesday';
                  break;
                case 3:
                  weekDay = 'Thursday';
                  break;
                case 4:
                  weekDay = 'Friday';
                  break;
                case 5:
                  weekDay = 'Saturday';
                  break;
                case 6:
                  weekDay = 'Sunday';
                  break;
              }
              return BarTooltipItem(weekDay + '\n' + (rod.y - 1).toString(),
                  TextStyle(color: Colors.yellow));
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! FlPanEnd &&
                barTouchResponse.touchInput is! FlLongPressEnd) {
              _touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              _touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'M';
              case 1:
                return 'T';
              case 2:
                return 'W';
              case 3:
                return 'T';
              case 4:
                return 'F';
              case 5:
                return 'S';
              case 6:
                return 'S';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 32,
          reservedSize: 14,
          getTitles: (value) {
            if (value == 0) {
              return '1';
            } else if (value == 10) {
              return '5';
            } else if (value == 19) {
              return '10';
            } else {
              return '';
            }
          },
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }

  BarChartData randomData() {
    return BarChartData(
      barTouchData: const BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: false,
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 1:
            return makeGroupData(1, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 2:
            return makeGroupData(2, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 3:
            return makeGroupData(3, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 4:
            return makeGroupData(4, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 5:
            return makeGroupData(5, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 6:
            return makeGroupData(6, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          default:
            return null;
        }
      }),
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
        animDuration + const Duration(milliseconds: 50));
    if (_loading) {
      refreshState();
    }
  }
}
