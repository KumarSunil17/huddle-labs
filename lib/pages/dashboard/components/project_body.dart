import 'package:flutter/material.dart';

import 'dashboard_chart/dashboard_chart.dart';

class ProjectBody extends StatefulWidget {
  @override
  _ProjectBodyState createState() => _ProjectBodyState();
}

class _ProjectBodyState extends State<ProjectBody> {
  final GlobalKey<DashboardChartState> _graphKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 9),
        child: DashboardChart(key: _graphKey));
  }
}
