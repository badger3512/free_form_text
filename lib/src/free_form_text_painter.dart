part of '../free_form_text.dart';

class FreeFormTextPainter {
  final ui.Canvas canvas;
  FreeFormTextPainter(this.canvas);
  void paintCharacter(StyledCharacter char, ui.Offset offset) {
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
      print(e.toString());
      canvas.restore();
    }
    canvas.restore();
  }

  Future<void> paintText(
      {required FreeFormText text,
      required ui.Offset offset,
      double angle = 0.0}) async {
    var currentOffset = const ui.Offset(0.0, 0.0);
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.rotate(-angle * degrees2Radians);
    for (var i = 0; i < text.buffer.length; i++) {
      var currentChar = text.buffer[i];
      paintCharacter(currentChar, currentOffset);
      var spacing = currentChar.mStyle.letterSpacing ?? 0.0;
      currentOffset = currentOffset.translate(
          currentChar.image!.width.toDouble() + spacing, 0.0);
      // cosAngle * (currentChar.image!.width.toDouble() + spacing),
      // sinAngle * (currentChar.image!.height.toDouble()));
    }
    canvas.restore();
  }

  ui.TextStyle convert2UiStyle(m.TextStyle mStyle) {
    return ui.TextStyle(
        color: mStyle.color,
        decoration: mStyle.decoration,
        decorationColor: mStyle.decorationColor,
        decorationStyle: mStyle.decorationStyle,
        decorationThickness: mStyle.decorationThickness,
        fontWeight: mStyle.fontWeight,
        fontStyle: mStyle.fontStyle,
        textBaseline: mStyle.textBaseline,
        fontFamily: mStyle.fontFamily,
        fontFamilyFallback: mStyle.fontFamilyFallback,
        fontSize: mStyle.fontSize,
        letterSpacing: mStyle.letterSpacing,
        wordSpacing: mStyle.wordSpacing,
        height: mStyle.height,
        leadingDistribution: mStyle.leadingDistribution,
        locale: mStyle.locale,
        background: mStyle.background,
        foreground: mStyle.foreground,
        shadows: mStyle.shadows,
        fontFeatures: mStyle.fontFeatures,
        fontVariations: mStyle.fontVariations);
  }

  double fetchMaxWidth(List<StyledCharacter> text) {
    int width = -999;
    for (var char in text) {
      width = math.max(width, char.image!.width);
    }
    return width.toDouble();
  }

  void paintTextAlongPath(FreeFormText text, List<ui.Offset> path,
      [bool lenient = false]) {
    final pathLength = OffsetUtility.pathLength(path);
    final textLength = text.textLength();
    var maxWidth = fetchMaxWidth(text.buffer);
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
            paintCharacter(currentChar, const ui.Offset(0.0, 0.0));
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
