part of '../free_form_text.dart';
/// Styled character representation.
class StyledCharacter {
  /// The character codepoint
  int codePoint;
  /// The [ui.TextStyle] style
  late ui.TextStyle style;
  /// The [painting.TextStyle] style
  m.TextStyle mStyle;
  /// The bit map image for the character and style
  ui.Image? image;
  StyledCharacter(this.codePoint, this.mStyle) {
    style = _convert2UiStyle(mStyle);
  }
  /// Hash code used for the [CharacterCache]
  @override
  int get hashCode => codePoint.hashCode + style.hashCode;

  /// Equals override use for the [CharacterCache]
  @override
  bool operator ==(Object other) {
    return hashCode == other.hashCode;
  }
  /// Convert from a [m.TextStyle] to a [ui.TextStyle]
  ui.TextStyle _convert2UiStyle(m.TextStyle mStyle) {
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
