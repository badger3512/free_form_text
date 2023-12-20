part of '../free_form_text.dart';

class FreeFormText {
  final List<StyledCharacter> buffer = List.empty(growable: true);
  bool isBuilt = false;
  String label;
  m.TextStyle? style;
  m.BuildContext context;
  FreeFormText({required this.label, required this.context, this.style}) {
    style ??= m.DefaultTextStyle.of(context).style;
  }

  Future<FreeFormText> layout() async {
    for (var code in label.runes) {
      var char = StyledCharacter(code, style!);
      StyledCharacter? test = cache.get(char);
      if (test == null) {
        char.image = await createImage(char);
        cache.put(char);
        buffer.add(char);
      } else {
        char = test;
        buffer.add(char);
      }
    }
    isBuilt = true;
    return this;
  }

  double textLength(){
    double length = 0.0;
    if(!isBuilt){
      return length;
    }
    for(StyledCharacter char in buffer){
      var spacing = char.mStyle.letterSpacing ?? 0.0;
      length += (char.image!.width + spacing);
    }
    return length;
  }

  Future<ui.Image?> createImage(StyledCharacter char) async {
    final str = String.fromCharCode(char.codePoint);
    var oldStyle = char.mStyle;
    ui.TextStyle style = ui.TextStyle(
        color: oldStyle.color,
        fontStyle: oldStyle.fontStyle,
        fontSize: oldStyle.fontSize,
        fontFamily: oldStyle.fontFamily,
        letterSpacing: oldStyle.letterSpacing);
    final textSpan = m.TextSpan(
      text: str,
      style: char.mStyle,
    );
    final tp = m.TextPainter(text: textSpan, textDirection: ui.TextDirection.ltr);
    tp.layout();
    var width = tp.width;
    var height = tp.height;
    tp.dispose();
    var builder = ui.ParagraphBuilder(char.mStyle.getParagraphStyle());
    builder.pushStyle(style);
    builder.addText(str);
    ui.Paragraph paragraph = builder.build();
    paragraph.layout(const ui.ParagraphConstraints(width: 100));
    final recorder = ui.PictureRecorder();
    var canvas = m.Canvas(recorder);
    canvas.drawParagraph(paragraph, const ui.Offset(0.0, 0.0));
    final picture = recorder.endRecording();
    ui.Image res = await picture.toImage(width.toInt(), height.toInt());
    ByteData? data = await res.toByteData(format: ui.ImageByteFormat.png);
    var dir = await getApplicationDocumentsDirectory();
    var file = io.File('${dir.path}/char_$str.png');
    await file.writeAsBytes(data!.buffer.asUint8List());
    return res;
  }
}
