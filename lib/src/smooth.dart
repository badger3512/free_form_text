part of '../free_form_text.dart';

class CubicBezier {
  Map<int, List<InterpolationPoint>> lookup = {};
  final control = SmootherControl();
  CubicBezier();

  /// Calculates a pair of Bezier control points for each vertex in an array of ui.Offsets
  ///
  List<List<ui.Offset>> _getLineControlPoints(
      List<ui.Offset> coordinates, double alpha) {
    if (alpha < 0.0 || alpha > 1.0) {
      throw Exception('alpha must be a value between 0 and 1 inclusive');
    }

    final int n = coordinates.length;
    final ctrl = List<List<ui.Offset>>.empty(growable:true);
    for(int i=0;i<n;i++){
      ctrl.add(List.empty(growable:true));
    }

    final v = List<ui.Offset>.filled(3, ui.Offset(0.0,0.0));
    final mid = List<ui.Offset>.filled(2, ui.Offset(0.0,0.0));

    var anchor = ui.Offset.zero;
    final vDistance = List.filled(2, 0.0);

    // Start with dummy coordinate preceding first real coordinate
    v[1] = ui.Offset(2 * coordinates[0].dx - coordinates[1].dx,
        2 * coordinates[0].dy - coordinates[1].dy);
    v[2] = coordinates[0];

    // Dummy coordinate for end of line
    ui.Offset vN = ui.Offset(2 * coordinates[n - 1].dx - coordinates[n - 2].dx,
        2 * coordinates[n - 1].dy - coordinates[n - 2].dy);
    mid[1] = ui.Offset((v[1].dx + v[2].dx) / 2.0, (v[1].dy + v[2].dy) / 2.0);
    vDistance[1] = OffsetUtility.offsetDistance(v[1], v[2]);

    for (int i = 0; i < n; i++) {
      List<ui.Offset> l1 = List<ui.Offset>.empty(growable:true);
      v[0] = v[1];
      v[1] = v[2];
      v[2] = (i < n - 1 ? coordinates[i + 1] : vN);

      mid[0] = ui.Offset(mid[1].dx, mid[1].dy);
      mid[1] = ui.Offset((v[1].dx + v[2].dx) / 2.0, (v[1].dy + v[2].dy) / 2.0);

      vDistance[0] = vDistance[1];
      vDistance[1] = OffsetUtility.offsetDistance(v[1], v[2]);

      double p = vDistance[0] / (vDistance[0] + vDistance[1]);
      anchor = ui.Offset(mid[0].dx + p * (mid[1].dx - mid[0].dx),
          mid[0].dy + p * (mid[1].dy - mid[0].dy));
      double xDelta = anchor.dx - v[1].dx;
      double yDelta = anchor.dy - v[1].dy;

      var ctx = ui.Offset(
          alpha * (v[1].dx - mid[0].dx + xDelta) + mid[0].dx - xDelta,
          alpha * (v[1].dy - mid[0].dy + yDelta) + mid[0].dy - yDelta);

      var cty = ui.Offset(
          alpha * (v[1].dx - mid[1].dx + xDelta) + mid[1].dx - xDelta,
          alpha * (v[1].dy - mid[1].dy + yDelta) + mid[1].dy - yDelta);
      l1.add(ctx);
      l1.add(cty);
      ctrl[i].addAll(l1);
    }

    return ctrl;
  }

  ///
  /// Calculates a pair of Bezier control points for each vertex in an array of ui.Offsets
  ///
  List<List<ui.Offset>> _getRingControlPoints(
      List<ui.Offset> coordinates, int n, double alpha) {
    if (alpha < 0.0 || alpha > 1.0) {
      throw Exception("alpha must be a value between 0 and 1 inclusive");
    }
    final ctrl = List<List<ui.Offset>>.empty(growable:true);
    for(int i=0;i<n;i++){
      ctrl.add(List.empty(growable:true));
    }
    final v = List<ui.Offset>.filled(3, ui.Offset.zero);
    final mid = List<ui.Offset>.filled(2, ui.Offset.zero);
    var anchor = ui.Offset.zero;
    final vDistance = List.filled(2, 0.0);

    v[1] = coordinates[n - 1];
    v[2] = coordinates[0];
    mid[1] = ui.Offset((v[1].dx + v[2].dx) / 2.0, (v[1].dy + v[2].dy) / 2.0);
    vDistance[1] = OffsetUtility.offsetDistance(v[1], v[2]);

    for (int i = 0; i < n; i++) {
      List<ui.Offset> l1 = List<ui.Offset>.empty(growable:true);
      v[0] = v[1];
      v[1] = v[2];
      v[2] = coordinates[(i + 1) % n];
      mid[0] = ui.Offset(mid[1].dx, mid[1].dy);
      mid[1] = ui.Offset((v[1].dx + v[2].dx) / 2.0, (v[1].dy + v[2].dy) / 2.0);

      vDistance[0] = vDistance[1];
      vDistance[1] = OffsetUtility.offsetDistance(v[1], v[2]);

      double p = vDistance[0] / (vDistance[0] + vDistance[1]);
      final dx = mid[0].dx + p * (mid[1].dx - mid[0].dx);
      final dy = mid[0].dy + p * (mid[1].dy - mid[0].dy);
      anchor = ui.Offset(dx, dy);
      double xDelta = anchor.dx - v[1].dx;
      double yDelta = anchor.dy - v[1].dy;

      var ctx = ui.Offset(
          alpha * (v[1].dx - mid[0].dx + xDelta) + mid[0].dx - xDelta,
          alpha * (v[1].dy - mid[0].dy + yDelta) + mid[0].dy - yDelta);

      var cty = ui.Offset(
          alpha * (v[1].dx - mid[1].dx + xDelta) + mid[1].dx - xDelta,
          alpha * (v[1].dy - mid[1].dy + yDelta) + mid[1].dy - yDelta);
      l1.add(ctx);
      l1.add(cty);
      ctrl[i].addAll(l1);
    }

    return ctrl;
  }

  /// Calculates vertices along a cubic Bezier curve given start point, end point and two control
  /// points.
  ///
  List<ui.Offset> _cubicBezier(final ui.Offset start, final ui.Offset end,
      final ui.Offset ctrl1, final ui.Offset ctrl2, final int nv) {
    final curve = List<ui.Offset>.filled(nv, ui.Offset.zero);

//    final buf = List<ui.Offset>.filled(3, ui.Offset.zero);
    curve[0] = ui.Offset(start.dx, start.dy);
    curve[nv - 1] = ui.Offset(end.dx, end.dy);
    var ip = _getInterpolationPoints(nv);

    for (int i = 1; i < nv - 1; i++) {
      var dx = ip[i].t[0] * start.dx +
          ip[i].t[1] * ctrl1.dx +
          ip[i].t[2] * ctrl2.dx +
          ip[i].t[3] * end.dx;
      dx /= ip[i].tsum;
      var dy = ip[i].t[0] * start.dy +
          ip[i].t[1] * ctrl1.dy +
          ip[i].t[2] * ctrl2.dy +
          ip[i].t[3] * end.dy;
      dy /= ip[i].tsum;
      curve[i] = ui.Offset(dx, dy);
    }

    return curve;
  }

  /// Gets the interpolation parameters for a Bezier curve approximated by the given number of
  /// vertices.
  ///
  List<InterpolationPoint> _getInterpolationPoints(int numPoints) {
    List<InterpolationPoint>? ref = lookup[numPoints];
    List<InterpolationPoint>? ip;
    if (ref != null) {
      ip = ref;
    }

    if (ip == null) {
      ip = List<InterpolationPoint>.filled(numPoints, InterpolationPoint());

      for (int i = 0; i < numPoints; i++) {
        double t = i.toDouble() / (numPoints - 1);
        double tc = 1.0 - t;

        ip[i] = InterpolationPoint();
        ip[i].t[0] = tc * tc * tc;
        ip[i].t[1] = 3.0 * tc * tc * t;
        ip[i].t[2] = 3.0 * tc * t * t;
        ip[i].t[3] = t * t * t;
        ip[i].tsum = ip[i].t[0] + ip[i].t[1] + ip[i].t[2] + ip[i].t[3];
      }

      lookup[numPoints] = ip;
    }

    return ip;
  }

  List<ui.Offset> smooth(List<ui.Offset> coordinates, double alpha) {
    if (coordinates.first != coordinates.last) {
      return _smoothLine(coordinates, alpha);
    } else {
      return _smoothRing(coordinates, alpha);
    }
  }

  /// Creates a new line which is a smoothed version of the input.
  ///
  List<ui.Offset> _smoothLine(List<ui.Offset> ls, double alpha) {
    var coordinates = ls;

    var controlPoints = _getLineControlPoints(coordinates, alpha);

    final int n = coordinates.length;
    List<ui.Offset> smoothCoordinates = List<ui.Offset>.empty(growable: true);
    double dist;
    for (int i = 0; i < n - 1; i++) {
      dist = OffsetUtility.offsetDistance(coordinates[i], coordinates[i + 1]);
      if (dist < control.minLength) {
        // segment too short - just copy input coordinate
        smoothCoordinates.add(ui.Offset(coordinates[i].dx, coordinates[i].dy));
      } else {
        int smoothN = control.numVertices;
        var segment = _cubicBezier(coordinates[i], coordinates[i + 1],
            controlPoints[i][1], controlPoints[i + 1][0], smoothN);

        int copyN = i < n - 1 ? segment.length - 1 : segment.length;
        for (int k = 0; k < copyN; k++) {
          smoothCoordinates.add(segment[k]);
        }
      }
    }
    smoothCoordinates.add(coordinates[n - 1]);

    return smoothCoordinates;
  }

  ///
  /// Creates a smoothed version of the input ring (line with equal first and last points)
  ///
  List<ui.Offset> _smoothRing(List<ui.Offset> coordinates, double alpha) {
    final n = coordinates.length - 1;

    var controlPoints = _getRingControlPoints(coordinates, n, alpha);

    List<ui.Offset> smoothCoords = List<ui.Offset>.empty(growable: true);
    double dist;
    for (int i = 0; i < n; i++) {
      int next = (i + 1) % n;
      dist = OffsetUtility.offsetDistance(coordinates[i], coordinates[next]);
      if (dist < control.minLength) {
        // segment too short - just copy input coordinate
        smoothCoords.add(ui.Offset(coordinates[i].dx, coordinates[i].dy));
      } else {
        int smoothN = control.numVertices;
        var segment = _cubicBezier(coordinates[i], coordinates[next],
            controlPoints[i][1], controlPoints[next][0], smoothN);

        int copyN = i < n - 1 ? segment.length - 1 : segment.length;
        for (int k = 0; k < copyN; k++) {
          smoothCoords.add(segment[k]);
        }
      }
    }
    return smoothCoords;
  }
}

class InterpolationPoint {
  List<double> t = List<double>.filled(4, 0.0);
  double tsum = 0.0;
  InterpolationPoint();
}

class SmootherControl {
  int numVertices = 10;
  double minLength = 0.0;
  SmootherControl();
}
