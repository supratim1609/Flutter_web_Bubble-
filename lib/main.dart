import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Bubbles',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Random _random = Random();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Start the timer to add bubbles periodically
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      _addBubble();
    });
    // Start the timer to update bubble positions
    Timer.periodic(Duration(milliseconds: 16), (timer) {
      _updateBubbles();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // Set dark grey background
      appBar: AppBar(
        backgroundColor: Colors.black26,
        elevation: 0.0,
        title: Text('Flutter Bubbles'),
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            for (var bubble in bubbles)
              _buildBubble(
                left: bubble['left']!,
                top: bubble['top']!,
                diameter: bubble['diameter']!,
                borderColor: bubble['borderColor']!,
              ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> bubbles = [];

  void _addBubble() {
    setState(() {
      double diameter = _random.nextDouble() * 100 + 20; // Random size between 20 and 70
      double left = _random.nextDouble() * (MediaQuery.of(context).size.width - diameter);
      double top = _random.nextDouble() * (MediaQuery.of(context).size.height - diameter);

      // Generate a random color for the border
      Color randomColor = Color.fromRGBO(
        _random.nextInt(256),
        _random.nextInt(256),
        _random.nextInt(256),
        1.0,
      );

      bubbles.add({
        'left': left,
        'top': top,
        'diameter': diameter,
        'speedX': _random.nextDouble() * 4 - 2, // Random horizontal speed between -2 and 2
        'speedY': _random.nextDouble() * 4 - 2, // Random vertical speed between -2 and 2
        'borderColor': randomColor,
      });
    });
  }

  void _updateBubbles() {
    setState(() {
      for (var bubble in bubbles) {
        bubble['left'] = (bubble['left']! + bubble['speedX']) % MediaQuery.of(context).size.width;
        bubble['top'] = (bubble['top']! + bubble['speedY']) % MediaQuery.of(context).size.height;
      }
    });
  }

  Widget _buildBubble({
    required double left,
    required double top,
    required double diameter,
    required Color borderColor,
  }) {
    return Positioned(
      left: left,
      top: top,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 16), // Update the UI every frame (60fps)
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: 2), // Border color
          color: Colors.black26.withOpacity(0.3), // Set bubbles as transparent
        ),
      ),
    );
  }
}
