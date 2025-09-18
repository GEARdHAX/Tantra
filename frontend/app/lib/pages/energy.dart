import 'dart:math';
import 'package:flutter/material.dart';

class WindFarmDemo extends StatelessWidget {
  const WindFarmDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          Positioned.fill(
            child: CustomPaint(
              painter: LandscapePainter(),
            ),
          ),

          Positioned.fill(
            child: Stack(
              children: const [
                WindTurbine(x: 150, y: 400, height: 180),
                WindTurbine(x: 250, y: 420, height: 150),
                WindTurbine(x: 350, y: 380, height: 200),
              ],
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.white.withOpacity(0.9),
                child: const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "⚡ Energy Dashboard",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WindTurbine extends StatefulWidget {
  final double x;
  final double y;
  final double height;

  const WindTurbine({
    super.key,
    required this.x,
    required this.y,
    this.height = 150,
  });

  @override
  State<WindTurbine> createState() => _WindTurbineState();
}

class _WindTurbineState extends State<WindTurbine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
    AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..repeat(); // keeps spinning
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final angle = _controller.value * 2 * pi;

        return CustomPaint(
          painter: _WindTurbinePainter(
            x: widget.x,
            y: widget.y,
            height: widget.height,
            angle: angle,
          ),
        );
      },
    );
  }
}

class _WindTurbinePainter extends CustomPainter {
  final double x, y, height, angle;

  _WindTurbinePainter({
    required this.x,
    required this.y,
    required this.height,
    required this.angle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6   
      ..strokeCap = StrokeCap.round; 


    canvas.drawRect(Rect.fromLTWH(x - 5, y - height, 10, height), paint);

    final hub = Offset(x, y - height);
    paint.color = Colors.grey.shade300;
    canvas.drawCircle(hub, 6, paint);


    paint.color = Colors.white;
    const bladeLength = 60.0;

    for (int i = 0; i < 3; i++) {
      final bladeAngle = angle + (i * 2 * pi / 3);
      final dx = cos(bladeAngle) * bladeLength;
      final dy = sin(bladeAngle) * bladeLength;
      canvas.drawLine(hub, Offset(hub.dx + dx, hub.dy + dy), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WindTurbinePainter oldDelegate) => true;
}

/// 🌄 Landscape
class LandscapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Sky
    paint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.blue.shade300, Colors.blue.shade100],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height / 2));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Grass
    paint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.green.shade400, Colors.green.shade200],
    ).createShader(Rect.fromLTWH(0, size.height / 2, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, size.height / 2, size.width, size.height),
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
