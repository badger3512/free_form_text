import 'package:flutter/material.dart';
import 'package:free_form_text/free_form_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Free Form Text Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: const Center(
        child: TextExample(),
      ),
    );
  }
}

class TextExample extends StatefulWidget {
  const TextExample({super.key});

  @override
  State<TextExample> createState() => _TextExampleState();
}

class _TextExampleState extends State<TextExample> {
  late Future<FreeFormText> textFuture;
  _TextExampleState();
  @override
  void initState() {
    super.initState();
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
  }

  @override
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
}

class ExampleTextPainter extends CustomPainter {
  BuildContext context;
  FreeFormText text;
  ExampleTextPainter(this.context, this.text);
  @override
  void paint(Canvas canvas, Size size) {
    var painter = FreeFormTextPainter(canvas);
    painter.paintText(
        text: text, offset: const Offset(50.0, 200.0), angle: 30.0);
    painter.paintText(
        text: text, offset: const Offset(50.0, 250.0), angle: -30.0);
    List<Offset> path = List.empty(growable: true);
    path.add(const Offset(50.0, 375.0));
    path.add(const Offset(100.0, 375.0));
    path.add(const Offset(125.0, 400.0));
    path.add(const Offset(150.0, 425.0));
    path.add(const Offset(175.0, 450.0));
    path.add(const Offset(225.0, 475.0));
    path.add(const Offset(250.0, 475.0));
    path.add(const Offset(275.0, 450.0));
    final smoothPath = CubicBezier().smooth(path, 0.5);
    Paint paint = Paint();
    paint.color = const Color(0xFF0000FF);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2.0;
    Path linePath = Path();
    linePath.moveTo(smoothPath[0].dx, smoothPath[0].dy);
    for (var i = 1; i < smoothPath.length; i++) {
      linePath.lineTo(smoothPath[i].dx, smoothPath[i].dy);
    }
    canvas.drawPath(linePath, paint);
    try {
      painter.paintTextAlongPath(text, smoothPath);
    } on FreeFormTextException catch (e) {
      print(e.reason);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
