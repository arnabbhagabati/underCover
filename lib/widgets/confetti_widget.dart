import 'dart:math';
import 'package:flutter/material.dart';

class ConfettiWidget extends StatefulWidget {
  final Widget child;

  const ConfettiWidget({
    super.key,
    required this.child,
  });

  @override
  State<ConfettiWidget> createState() => _ConfettiWidgetState();
}

class _ConfettiWidgetState extends State<ConfettiWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    for (int i = 0; i < 60; i++) {
      _particles.add(_Particle(_random));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        IgnorePointer(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                size: Size.infinite,
                painter: _ConfettiPainter(_particles, _controller.value),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Particle {
  late double x;
  late double y;
  late double size;
  late Color color;
  late double vx;
  late double vy;
  late double rotation;
  late double rotationSpeed;

  _Particle(Random random) {
    reset(random, isInitial: true);
  }

  void reset(Random random, {bool isInitial = false}) {
    x = random.nextDouble();
    y = isInitial ? random.nextDouble() * -0.5 : -0.1;
    size = random.nextDouble() * 8 + 4;
    vx = (random.nextDouble() - 0.5) * 0.2;
    vy = random.nextDouble() * 0.4 + 0.3;
    rotation = random.nextDouble() * 2 * pi;
    rotationSpeed = (random.nextDouble() - 0.5) * 4;

    const colors = [
      Color(0xFF2563EB), // Blue
      Color(0xFF38BDF8), // Sky Blue
      Color(0xFF10B981), // Green
      Color(0xFFEF4444), // Red
      Color(0xFFA855F7), // Purple
      Color(0xFFF59E0B), // Yellow/Amber
    ];
    color = colors[random.nextInt(colors.length)];
  }

  void update(double dt, Random random) {
    x += vx * dt;
    y += vy * dt;
    rotation += rotationSpeed * dt;

    if (y > 1.2) {
      reset(random);
    }
  }
}

class _ConfettiPainter extends CustomPainter {
  final List<_Particle> particles;
  final double time;
  final Random _random = Random();

  _ConfettiPainter(this.particles, this.time);

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      p.update(0.016, _random);

      final paint = Paint()
        ..color = p.color
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(p.x * size.width, p.y * size.height);
      canvas.rotate(p.rotation);
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: p.size,
          height: p.size * 0.6,
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
