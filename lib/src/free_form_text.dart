part of '../free_form_text.dart';

/// The basis for a [StyledCharacter] string. (Not a widget)
class FreeFormText {
  final List<StyledCharacter> buffer = List.empty(growable: true);
  bool _isBuilt = false;
  String label;
  m.TextStyle? style;
  m.BuildContext context;

  /// Constructor for styled text. If style if omitted, the context default is assumed
  FreeFormText({required this.label, required this.context, this.style}) {
    style ??= m.DefaultTextStyle.of(context).style;
  }

  /// Layout the text string by establishing bit mapped representations for the runes.
  Future<FreeFormText> layout() async {
    for (var code in label.runes) {
      var char = StyledCharacter(code, style!);
      StyledCharacter? test = cache.get(char);
      if (test == null) {
        char.image = await _createImage(char);
        cache.put(char);
        buffer.add(char);
      } else {
        char = test;
        buffer.add(char);
      }
    }
    _isBuilt = true;
    return this;
  }

  /// Compute the length of the laid-out text string
  double textLength() {
    var length = 0.0;
    if (!_isBuilt) {
      return length;
    }
    for (StyledCharacter char in buffer) {
      final spacing = char.mStyle.letterSpacing ?? 0.0;
      length += (char.image!.width + spacing);
    }
    return length;
  }

  /// Compute the bounds for the laid-out text
  math.Rectangle<double> textBounds(){
    final width = textLength();
    double height = -1.0;
    for(StyledCharacter char in buffer){
      height = math.max((char.image!.height.toDouble()),height);
    }
    return math.Rectangle(0.0,0.0,width,height);
  }

  /// Create a bit map image for the represented character
  Future<ui.Image?> _createImage(StyledCharacter char) async {
    final str = String.fromCharCode(char.codePoint);
    final textSpan = m.TextSpan(
      text: str,
      style: char.mStyle,
    );
    final tp =
        m.TextPainter(text: textSpan, textDirection: ui.TextDirection.ltr);
    tp.layout();
    final width = tp.width;
    final height = tp.height;
    tp.dispose();
    final builder = ui.ParagraphBuilder(char.mStyle.getParagraphStyle());
    builder.pushStyle(char.style);
    builder.addText(str);
    ui.Paragraph paragraph = builder.build();
    paragraph.layout(const ui.ParagraphConstraints(width: 100));
    final recorder = ui.PictureRecorder();
    final canvas = m.Canvas(recorder);
    canvas.drawParagraph(paragraph, const ui.Offset(0.0, 0.0));
    final picture = recorder.endRecording();
    ui.Image res = await picture.toImage(width.toInt(), height.toInt());
    // ByteData? data = await res.toByteData(format: ui.ImageByteFormat.png);
    // final dir = await io.Directory.systemTemp;
    // final file = io.File('${dir.path}/char_$str.png');
    // await file.writeAsBytes(data!.buffer.asUint8List());
    return res;
  }
}
