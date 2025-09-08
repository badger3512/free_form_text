# free_form_text

An API for painting styled text to 
a [Canvas](https://api.flutter.dev/flutter/dart-ui/Canvas-class.html).

Text is styled with the [TextStyle](https://api.flutter.dev/flutter/dart-ui/TextStyle-class.html) class and can be painted at any arbitrary angle as well as along a defined path. The API should be useful for applications that require angled and free form text such as games or GIS mapping.

## Features

- Style the text with [TextStyle](https://api.flutter.dev/flutter/dart-ui/TextStyle-class.html).
- Paint text at arbitrary angles.
- Paint text along a specified path defined as a List of [Offset](https://api.flutter.dev/flutter/dart-ui/Offset-class.html).

## Getting started

To use this plugin, add `free_form_text` as a dependency in your pubspec.yaml file. For example:
```yaml
dependencies:
  free_form_text: '^0.4.4'
```
## Usage

To apply the API, import package:free_form_text/free_form_text.dart, create a Future<FreeFormText\> and use it in a FutureBuilder that includes
a [CustomPaint](https://api.flutter.dev/flutter/widgets/CustomPaint-class.html) 
widget as illustrated below. The actual painting is done in a 
[CustomPainter](https://api.flutter.dev/flutter/rendering/CustomPainter-class.html).

Create a FreeFormText object:
```dart
    FreeFormText text = FreeFormText(
        label: 'Lorem ipsum dolor sit amet.',
        context: context,
        style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            wordSpacing: 2.0,
            letterSpacing: 0.5,
            fontWeight: FontWeight.bold));
    Future<FreeFormText> textFuture = text.layout();
```
Then paint it in a CustomPainter:
```dart
class ExampleTextPainter extends CustomPainter {
  FreeFormText text;
  ExampleTextPainter(this.text);
  @override
  void paint(Canvas canvas, Size size) {
    var painter = FreeFormTextPainter(canvas);
    painter.paintText(
        text: text, offset: const Offset(50.0, 200.0), angle: 30.0);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
```
