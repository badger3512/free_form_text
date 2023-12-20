# free_form_text

An API for painting styled text to 
a [Canvas](https://api.flutter.dev/flutter/dart-ui/Canvas-class.html).

Text is styled with the [TextStyle](https://api.flutter.dev/flutter/dart-ui/TextStyle-class.html) class and can be painted at any arbitrary angle as well as along a defined path.

## Features

- Style the text with [TextStyle](https://api.flutter.dev/flutter/dart-ui/TextStyle-class.html).
- Paint text at arbitrary angles.
- Paint text along a specified path defined as a List of [Offset](https://api.flutter.dev/flutter/dart-ui/Offset-class.html).

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

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
    textFuture = text.layout();
```
...
```dart
  Widget build(BuildContext context) {
    return FutureBuilder<FreeFormText>(
        future: textFuture,
        builder: (BuildContext context, AsyncSnapshot<FreeFormText> snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.zero,
                margin: const EdgeInsets.all(20.0),
                child: CustomPaint(
                  painter: ExampleTextPainter(context, snapshot.data!),
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
```
...
```dart
class ExampleTextPainter extends CustomPainter {
  BuildContext context;
  FreeFormText text;
  ExampleTextPainter(this.context, this.text);
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

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
