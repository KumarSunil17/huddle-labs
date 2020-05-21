import 'dart:ui';

import 'package:huddlelabs/pages/dashboard/components/dashboard_chart/extensions/path_extension.dart';

extension DashedLine on Canvas {
  /// draws a dashed line from passed in offsets
  void drawDashedLine(Offset from, Offset to, Paint painter, List<int> dashArray) {
    Path path = Path();
    path.moveTo(from.dx, from.dy);
    path.lineTo(to.dx, to.dy);
    path = path.toDashedPath(dashArray);
    this.drawPath(path, painter);
  }
}
