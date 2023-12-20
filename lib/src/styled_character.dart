part of '../free_form_text.dart';

class StyledCharacter {
  int codePoint;
  late ui.TextStyle style;
  m.TextStyle mStyle;
  ui.Image? image;
  StyledCharacter(this.codePoint, this.mStyle) {
    style = convert2UiStyle(mStyle);
  }
  @override
  int get hashCode => codePoint.hashCode + style.hashCode;

  @override
  bool operator ==(Object other) {
    return hashCode == other.hashCode;
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
}
