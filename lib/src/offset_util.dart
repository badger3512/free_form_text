part of '../free_form_text.dart';

const double degrees2Radians = math.pi / 180.0;

/// Stateless utility class implementing [Offset] operations
class OffsetUtility {
  /// Perform 2D interpolation into a path
  static ui.Offset? linearInterpolation2D(List<ui.Offset> path, double dist) {
    if (path.length < 2 || pathLength(path) < dist) {
      return null;
    }
    if (dist == 0) {
      return path.first;
    }
    var sum = 0.0;
    for (var i = 1; i < path.length; i++) {
      var d = offsetDistance(path[i - 1], path[i]);
      if (sum + d >= dist) {
        var dx = path[i].dx - path[i - 1].dx;
        var dy = path[i].dy - path[i - 1].dy;
        var scale = (dist - sum) / d;
        var x = path[i - 1].dx + scale * dx;
        var y = path[i - 1].dy + scale * dy;
        return ui.Offset(x, y);
      } else {
        sum += d;
      }
    }
    return null;
  }

  /// Compute the distance between to [Offset] points
  static double offsetDistance(ui.Offset p1, ui.Offset p2) {
    var dx = p2.dx - p1.dx;
    var dy = p2.dy - p1.dy;
    return math.sqrt(dx * dx + dy * dy);
  }

  /// Compute the length (distance) of a path
  static double pathLength(List<ui.Offset> path) {
    if (path.length < 2) {
      return 0.0;
    }
    var sum = 0.0;
    for (var i = 1; i < path.length; i++) {
      sum += offsetDistance(path[i - 1], path[i]);
    }
    return sum;
  }

  /// Determine the two [Offset] points that fall on either side a given point
  static List<ui.Offset> bracketOffset(List<ui.Offset> path, ui.Offset offset) {
    List<ui.Offset> bracketList = List.empty(growable: true);
    for (var i = 1; i < path.length; i++) {
      final td = offsetDistance(path[i - 1], path[i]);
      final t1 = offsetDistance(path[i - 1], offset);
      final t2 = offsetDistance(offset, path[i]);
      if ((t1 + t2 - td).abs() <= 0.001) {
        bracketList.add(path[i - 1]);
        bracketList.add(path[i]);
        break;
      }
    }
    return bracketList;
  }

  /// Determine the indices of the two [Offset] points that fall on either side a given point
  static List<int> bracketOffsetIndex(List<ui.Offset> path, ui.Offset offset) {
    List<int> bracketList = List.empty(growable: true);
    for (var i = 1; i < path.length; i++) {
      final td = offsetDistance(path[i - 1], path[i]);
      final t1 = offsetDistance(path[i - 1], offset);
      final t2 = offsetDistance(offset, path[i]);
      if ((t1 + t2 - td).abs() <= 0.001) {
        bracketList.add(i - 1);
        bracketList.add(i);
        break;
      }
    }
    return bracketList;
  }

  /// Compute the angle between two points
  static double offsetAngle(ui.Offset p1, ui.Offset p2) {
    var dx = p2.dx - p1.dx;
    var dy = p2.dy - p1.dy;
    return math.atan2(dy, dx) / degrees2Radians;
  }

  /// Compute the distance along a path to a given point
  static double distanceAlongPath(List<ui.Offset> path, ui.Offset offset) {
    var sum = 0.0;
    if (offset == path[0]) {
      return sum;
    }
    var bracketIndex = bracketOffsetIndex(path, offset);
    if (bracketIndex.isEmpty) {
      return sum;
    }
    if (bracketIndex[0] == 0) {
      return offsetDistance(path[0], offset);
    }
    for (var i = 1; i <= bracketIndex[0]; i++) {
      sum += offsetDistance(path[i - 1], path[i]);
    }
    sum += offsetDistance(path[bracketIndex[0]], offset);
    return sum;
  }
}
