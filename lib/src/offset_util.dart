part of '../free_form_text.dart';

const double degrees2Radians = math.pi / 180.0;

class OffsetUtility {
  static ui.Offset? linearInterpolation2D(List<ui.Offset> path, double dist) {
    if (path.length < 2 || pathLength(path) < dist) {
      return null;
    }
    if(dist == 0){
      return path.first;
    }
    var sum = 0.0;
    for (var i = 1; i < path.length; i++) {
      var d = offsetDistance(path[i - 1], path[i]);
      if (sum + d >= dist) {
        var dx = path[i].dx - path[i - 1].dx;
        var dy = path[i].dy - path[i - 1].dy;
        var scale = (dist - sum) / d;
        var x = path[i-1].dx + scale * dx;
        var y = path[i-1].dy + scale * dy;
        return ui.Offset(x, y);
      } else {
        sum += d;
      }
    }
    return null;
  }

  static double offsetDistance(ui.Offset p1, ui.Offset p2) {
    var dx = p2.dx - p1.dx;
    var dy = p2.dy - p1.dy;
    return math.sqrt(dx * dx + dy * dy);
  }

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

  static List<ui.Offset> bracketOffset(List<ui.Offset> path, ui.Offset offset) {
    List<ui.Offset> bracketList = List.empty(growable: true);
    for (var i = 1; i < path.length; i++) {
      final td = offsetDistance(path[i-1],path[i]);
      final t1 = offsetDistance(path[i-1],offset);
      final t2 = offsetDistance(offset,path[i]);
      if((t1+t2-td).abs() <= 0.001){
        bracketList.add(path[i-1]);
        bracketList.add(path[i]);
        break;
      }
    }
    return bracketList;
  }

  static List<int> bracketOffsetIndex(List<ui.Offset> path, ui.Offset offset) {
    List<int> bracketList = List.empty(growable: true);
    for (var i = 1; i < path.length; i++) {
      final td = offsetDistance(path[i-1],path[i]);
      final t1 = offsetDistance(path[i-1],offset);
      final t2 = offsetDistance(offset,path[i]);
      if((t1+t2-td).abs() <= 0.001){
        bracketList.add(i-1);
        bracketList.add(i);
        break;
      }
    }
    return bracketList;
  }
  static double offsetAngle(ui.Offset p1, ui.Offset p2) {
    var dx = p2.dx - p1.dx;
    var dy = p2.dy - p1.dy;
    return math.atan2(dy, dx) / degrees2Radians;
  }

  static double distanceAlongPath(List<ui.Offset> path, ui.Offset offset) {
    var sum = 0.0;
    if (offset == path[0]) {
      return sum;
    }
    var bracketIndex = bracketOffsetIndex(path,offset);
    if(bracketIndex.isEmpty){
      return sum;
    }
    if(bracketIndex[0] == 0){
      return offsetDistance(path[0],offset);
    }
    for(var i=1;i<=bracketIndex[0];i++){
      sum += offsetDistance(path[i-1],path[i]);
    }
    sum += offsetDistance(path[bracketIndex[0]],offset);
    return sum;
  }
}
