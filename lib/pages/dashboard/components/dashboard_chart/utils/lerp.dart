import 'dart:ui';

import '../index.dart';

List<Color> lerpColorList(List<Color> a, List<Color> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return Color.lerp(a[i], b[i], t);
    });
  } else {
    return b;
  }
}

List<double> lerpDoubleList(List<double> a, List<double> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return lerpDouble(a[i], b[i], t);
    });
  } else {
    return b;
  }
}

List<int> lerpIntList(List<int> a, List<int> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return lerpInt(a[i], b[i], t);
    });
  } else {
    return b;
  }
}

int lerpInt(int a, int b, double t) {
  return (a + (b - a) * t).round();
}

List<FlSpot> lerpFlSpotList(List<FlSpot> a, List<FlSpot> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return FlSpot.lerp(a[i], b[i], t);
    });
  } else {
    return b;
  }
}

List<HorizontalRangeAnnotation> lerpHorizontalRangeAnnotationList(
    List<HorizontalRangeAnnotation> a,
    List<HorizontalRangeAnnotation> b,
    double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return HorizontalRangeAnnotation.lerp(a[i], b[i], t);
    });
  } else {
    return b;
  }
}

List<VerticalRangeAnnotation> lerpVerticalRangeAnnotationList(
    List<VerticalRangeAnnotation> a,
    List<VerticalRangeAnnotation> b,
    double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return VerticalRangeAnnotation.lerp(a[i], b[i], t);
    });
  } else {
    return b;
  }
}

List<BarChartGroupData> lerpBarChartGroupDataList(
    List<BarChartGroupData> a, List<BarChartGroupData> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return BarChartGroupData.lerp(a[i], b[i], t);
    });
  } else {
    return b;
  }
}

List<BarChartRodData> lerpBarChartRodDataList(
    List<BarChartRodData> a, List<BarChartRodData> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return BarChartRodData.lerp(a[i], b[i], t);
    });
  } else {
    return b;
  }
}

List<BarChartRodStackItem> lerpBarChartRodStackList(
    List<BarChartRodStackItem> a, List<BarChartRodStackItem> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return BarChartRodStackItem.lerp(a[i], b[i], t);
    });
  } else {
    return b;
  }
}
