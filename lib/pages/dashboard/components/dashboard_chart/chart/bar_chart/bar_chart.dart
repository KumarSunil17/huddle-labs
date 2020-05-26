import 'package:flutter/cupertino.dart';
import 'package:huddlelabs/pages/dashboard/components/dashboard_chart/chart/base/base_chart/base_chart_painter.dart';
import 'package:huddlelabs/pages/dashboard/components/dashboard_chart/utils/utils.dart';

import '../../index.dart';
import 'bar_chart_painter.dart';

class BarChart extends ImplicitlyAnimatedWidget {
  final BarChartData data;

  const BarChart(
    this.data, {
    Duration swapAnimationDuration = const Duration(milliseconds: 150),
  }) : super(duration: swapAnimationDuration);

  @override
  BarChartState createState() => BarChartState();
}

class BarChartState extends AnimatedWidgetBaseState<BarChart> {
  BarChartDataTween _barChartDataTween;

  TouchHandler _touchHandler;

  final GlobalKey _chartKey = GlobalKey();

  final Map<int, List<int>> _showingTouchedTooltips = {};

  @override
  Widget build(BuildContext context) {
    final BarChartData showingData = _getDate();
    final BarTouchData touchData = showingData.barTouchData;

    return GestureDetector(
      onTapUp: (d) {
        final Size chartSize = _getChartSize();
        if (chartSize == null) {
          return;
        }

        final BarTouchResponse response = _touchHandler?.handleTouch(
            FlLongPressStart(d.localPosition), chartSize);
        if (_canHandleTouch(response, touchData)) {
          touchData.touchCallback(response);
        }
      },
//      onHover: (d) {
//        final Size chartSize = _getChartSize();
//        if (chartSize == null) {
//          return;
//        }
//
//        final BarTouchResponse response = _touchHandler?.handleTouch(
//            FlLongPressStart(d.localPosition - Offset(164, 221)), chartSize);
//        if (_canHandleTouch(response, touchData)) {
//          touchData.touchCallback(response);
//        }
//      },
      child: CustomPaint(
        key: _chartKey,
        size: getDefaultSize(MediaQuery.of(context).size),
        painter: BarChartPainter(
          _withTouchedIndicators(_barChartDataTween.evaluate(animation)),
          _withTouchedIndicators(showingData),
          (touchHandler) {
            setState(() {
              _touchHandler = touchHandler;
            });
          },
          textScale: MediaQuery.of(context).textScaleFactor,
        ),
      ),
    );
  }

  bool _canHandleTouch(BarTouchResponse response, BarTouchData touchData) {
    return response != null &&
        touchData != null &&
        touchData.touchCallback != null;
  }

  BarChartData _withTouchedIndicators(BarChartData barChartData) {
    if (barChartData == null) {
      return barChartData;
    }

    if (!barChartData.barTouchData.enabled ||
        !barChartData.barTouchData.handleBuiltInTouches) {
      return barChartData;
    }

    final List<BarChartGroupData> newGroups = [];
    for (int i = 0; i < barChartData.barGroups.length; i++) {
      final group = barChartData.barGroups[i];

      newGroups.add(
        group.copyWith(
          showingTooltipIndicators: _showingTouchedTooltips[i],
        ),
      );
    }

    return barChartData.copyWith(
      barGroups: newGroups,
    );
  }

  Size _getChartSize() {
    if (_chartKey.currentContext != null) {
      final RenderBox containerRenderBox =
          _chartKey.currentContext.findRenderObject();
      if (containerRenderBox.hasSize) {
        return containerRenderBox.size;
      }
      return null;
    } else {
      return null;
    }
  }

  BarChartData _getDate() {
    final barTouchData = widget.data.barTouchData;
    if (barTouchData.enabled && barTouchData.handleBuiltInTouches) {
      return widget.data.copyWith(
        barTouchData: widget.data.barTouchData
            .copyWith(touchCallback: _handleBuiltInTouch),
      );
    }
    return widget.data;
  }

  void _handleBuiltInTouch(BarTouchResponse touchResponse) {
    if (widget.data.barTouchData.touchCallback != null) {
      widget.data.barTouchData.touchCallback(touchResponse);
    }

    if (touchResponse.touchInput is FlPanStart ||
        touchResponse.touchInput is FlPanMoveUpdate ||
        touchResponse.touchInput is FlLongPressStart ||
        touchResponse.touchInput is FlLongPressMoveUpdate) {
      setState(() {
        if (touchResponse.spot == null) {
          _showingTouchedTooltips.clear();
          return;
        }
        final groupIndex = touchResponse.spot.touchedBarGroupIndex;
        final rodIndex = touchResponse.spot.touchedRodDataIndex;

        _showingTouchedTooltips.clear();
        _showingTouchedTooltips[groupIndex] = [rodIndex];
      });
    } else {
      setState(() {
        _showingTouchedTooltips.clear();
      });
    }
  }

  @override
  void forEachTween(visitor) {
    _barChartDataTween = visitor(
      _barChartDataTween,
      widget.data,
      (dynamic value) => BarChartDataTween(begin: value),
    );
  }
}
