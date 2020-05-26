import 'dart:ui';

import 'package:huddlelabs/pages/dashboard/components/dashboard_chart/chart/bar_chart/bar_chart_data.dart';
import 'package:flutter/material.dart';

import 'base_chart_painter.dart';
import 'touch_input.dart';

/// This class holds all data needed to [BaseChartPainter],
/// in this phase just the [FlBorderData] provided
/// to drawing chart border line,
/// see inherited samples:
/// [LineChartData], [BarChartData], [PieChartData]
abstract class BaseChartData {
  FlBorderData borderData;
  FlTouchData touchData;

  BaseChartData({
    this.borderData,
    this.touchData,
  }) {
    borderData ??= FlBorderData();
  }

  /// this function is used for animate between current and target data,
  /// used in the [BaseChartDataTween]
  BaseChartData lerp(BaseChartData a, BaseChartData b, double t);
}

/***** BorderData *****/

/// Border Data that contains
/// used the [Border] class to draw each side of border.
class FlBorderData {
  final bool show;
  Border border;

  FlBorderData({
    this.show = true,
    this.border,
  }) {
    border ??= Border.all(
      color: Colors.black,
      width: 1.0,
      style: BorderStyle.solid,
    );
  }

  static FlBorderData lerp(FlBorderData a, FlBorderData b, double t) {
    assert(a != null && b != null && t != null);
    return FlBorderData(
      show: b.show,
      border: Border.lerp(a.border, b.border, t),
    );
  }
}

/***** TouchData *****/

/// holds information about touch on the chart
class FlTouchData {
  /// determines enable or disable the touch in the chart
  final bool enabled;

  /// determines that charts should respond to normal touch events or not
  final bool enableNormalTouch;

  const FlTouchData(this.enabled, this.enableNormalTouch);
}

///***** AxisTitleData *****/

/// This class holds data about the description for each axis of the chart.
class FlAxisTitleData {
  final bool show;

  final AxisTitle leftTitle, topTitle, rightTitle, bottomTitle;

  const FlAxisTitleData({
    this.show = true,
    this.leftTitle = const AxisTitle(reservedSize: 16),
    this.topTitle = const AxisTitle(reservedSize: 16),
    this.rightTitle = const AxisTitle(reservedSize: 16),
    this.bottomTitle = const AxisTitle(reservedSize: 16),
  });

  static FlAxisTitleData lerp(FlAxisTitleData a, FlAxisTitleData b, double t) {
    return FlAxisTitleData(
      show: b.show,
      leftTitle: AxisTitle.lerp(a.leftTitle, b.leftTitle, t),
      rightTitle: AxisTitle.lerp(a.rightTitle, b.rightTitle, t),
      bottomTitle: AxisTitle.lerp(a.bottomTitle, b.bottomTitle, t),
      topTitle: AxisTitle.lerp(a.topTitle, b.topTitle, t),
    );
  }
}

/// specify each axis titles data
class AxisTitle {
  final bool showTitle;
  final double reservedSize;
  final TextStyle textStyle;
  final TextAlign textAlign;
  final double margin;
  final String titleText;

  const AxisTitle({
    this.showTitle = false,
    this.titleText = '',
    this.reservedSize = 14,
    this.textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 11,
    ),
    this.textAlign = TextAlign.center,
    this.margin = 4,
  });

  static AxisTitle lerp(AxisTitle a, AxisTitle b, double t) {
    return AxisTitle(
      showTitle: b.showTitle,
      titleText: b.titleText,
      reservedSize: lerpDouble(a.reservedSize, b.reservedSize, t),
      textStyle: TextStyle.lerp(
          a.textStyle.copyWith(fontSize: a.textStyle.fontSize),
          b.textStyle.copyWith(fontSize: b.textStyle.fontSize),
          t),
      textAlign: b.textAlign,
      margin: lerpDouble(a.margin, b.margin, t),
    );
  }
}

/***** TitlesData *****/

/// we use this typedef to determine which titles
/// we should show (according to the value),
/// we pass the value and get a boolean to show the title for that value.
typedef GetTitleFunction = String Function(double value);

String defaultGetTitle(double value) {
  return '$value';
}

/// This class is responsible to hold data about showing titles.
/// titles show on the each side of chart
class FlTitlesData {
  final bool show;

  final SideTitles leftTitles, topTitles, rightTitles, bottomTitles;

  const FlTitlesData({
    this.show = true,
    this.leftTitles = const SideTitles(reservedSize: 40, showTitles: true),
    this.topTitles = const SideTitles(reservedSize: 6),
    this.rightTitles = const SideTitles(
      reservedSize: 40,
    ),
    this.bottomTitles = const SideTitles(reservedSize: 22, showTitles: true),
  });

  static FlTitlesData lerp(FlTitlesData a, FlTitlesData b, double t) {
    return FlTitlesData(
      show: b.show,
      leftTitles: SideTitles.lerp(a.leftTitles, b.leftTitles, t),
      rightTitles: SideTitles.lerp(a.rightTitles, b.rightTitles, t),
      bottomTitles: SideTitles.lerp(a.bottomTitles, b.bottomTitles, t),
      topTitles: SideTitles.lerp(a.topTitles, b.topTitles, t),
    );
  }
}

/// specify each side titles data
class SideTitles {
  final bool showTitles;
  final GetTitleFunction getTitles;
  final double reservedSize;
  final TextStyle textStyle;
  final double margin;
  final double interval;
  final double rotateAngle;

  const SideTitles({
    this.showTitles = false,
    this.getTitles = defaultGetTitle,
    this.reservedSize = 22,
    this.textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 11,
    ),
    this.margin = 6,
    this.interval = 1.0,
    this.rotateAngle = 0.0,
  });

  static SideTitles lerp(SideTitles a, SideTitles b, double t) {
    return SideTitles(
      showTitles: b.showTitles,
      getTitles: b.getTitles,
      reservedSize: lerpDouble(a.reservedSize, b.reservedSize, t),
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
      margin: lerpDouble(a.margin, b.margin, t),
      interval: lerpDouble(a.interval, b.interval, t),
      rotateAngle: lerpDouble(a.rotateAngle, b.rotateAngle, t),
    );
  }
}

/// this class holds the touch response details,
/// specific touch details should be hold on the concrete child classes
class BaseTouchResponse {
  final FlTouchInput touchInput;

  BaseTouchResponse(this.touchInput);
}
