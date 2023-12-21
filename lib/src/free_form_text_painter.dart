part of '../free_form_text.dart';

/// Paints styled characters to a [Canvas]. Should be invoked from a [CustomPainter]
class FreeFormTextPainter {
  final ui.Canvas canvas;
  FreeFormTextPainter(this.canvas);

  /// Paint a character at a given location
  void _paintCharacter(StyledCharacter char, ui.Offset offset) {
    canvas.save();
    final height = char.image!.height;
    canvas.translate(offset.dx, offset.dy - height);
    try {
      m.paintImage(
          canvas: canvas,
          rect: m.Rect.fromLTWH(0.0, 0.0, char.image!.width.toDouble(),
              char.image!.height.toDouble()),
          image: char.image!);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      canvas.restore();
    }
    canvas.restore();
  }

  /// Paint a line of text beginning at a given location and at a specified angle
  void paintText(
      {required FreeFormText text,
      required ui.Offset offset,
      double angle = 0.0}) {
    var currentOffset = const ui.Offset(0.0, 0.0);
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.rotate(-angle * degrees2Radians);
    for (var i = 0; i < text.buffer.length; i++) {
      var currentChar = text.buffer[i];
      _paintCharacter(currentChar, currentOffset);
      var spacing = currentChar.mStyle.letterSpacing ?? 0.0;
      currentOffset = currentOffset.translate(
          currentChar.image!.width.toDouble() + spacing, 0.0);
    }
    canvas.restore();
  }

  /// Paint text along a specified path. Closed paths, e.g. first and last points are equal
  /// are treated as a special case.
  void paintTextAlongPath(FreeFormText text, List<ui.Offset> path,
      [bool lenient = false]) {
    final pathLength = OffsetUtility.pathLength(path);
    final textLength = text.textLength();
    if (text.textLength() > pathLength) {
      if (!lenient) {
        throw FreeFormTextException('Text length exceeds path length');
      }
    }
    final smoothPath = CubicBezier().smooth(path, 0.05);
    var currentOffset = smoothPath[0];
    var pathDistance =
        OffsetUtility.distanceAlongPath(smoothPath, currentOffset);
    for (var i = 0; i < text.buffer.length; i++) {
      var currentChar = text.buffer[i];
      if (pathDistance <= textLength) {
        ui.Offset? postOffset =
            OffsetUtility.linearInterpolation2D(smoothPath, pathDistance);
        if (postOffset != null) {
          List<ui.Offset> bracketList =
              OffsetUtility.bracketOffset(smoothPath, postOffset);
          if (bracketList.isNotEmpty) {
            canvas.save();
            final angle =
                OffsetUtility.offsetAngle(bracketList[0], bracketList[1]);
            canvas.translate(postOffset.dx, postOffset.dy);
            canvas.rotate(angle * degrees2Radians);
            _paintCharacter(currentChar, const ui.Offset(0.0, 0.0));
            canvas.restore();
            final spacing = currentChar.mStyle.letterSpacing ?? 0.0;
            final char = String.fromCharCode(currentChar.codePoint);
            final wordSpacing =
                (char == ' ') ? currentChar.mStyle.wordSpacing ?? 0.0 : 0.0;
            pathDistance +=
                currentChar.image!.width.toDouble() + spacing + wordSpacing;
          }
        }
      } else {
        return;
      }
    }
  }
}
