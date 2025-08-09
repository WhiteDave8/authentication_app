import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

/// Animated, layered background:
/// - Multi-stop gradient that drifts over time
/// - Soft "blobs" that float
/// - Subtle noise overlay
class AnimatedLuxuryBackground extends StatefulWidget {
  final Widget child;
  const AnimatedLuxuryBackground({super.key, required this.child});

  @override
  State<AnimatedLuxuryBackground> createState() => _AnimatedLuxuryBackgroundState();
}

class _AnimatedLuxuryBackgroundState extends State<AnimatedLuxuryBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 18))..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = _c.value;
        return CustomPaint(
          painter: _LuxuryPainter(t),
          child: Stack(
            children: [
              Positioned.fill(child: Container()), // for size
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: const SizedBox(),
                ),
              ),
              Positioned.fill(child: widget.child),
            ],
          ),
        );
      },
    );
  }
}

class _LuxuryPainter extends CustomPainter {
  final double t;
  _LuxuryPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Animated gradient background
    final colors = [
      const Color(0xFF0EA5E9),
      const Color(0xFF7C3AED),
      const Color(0xFFEC4899),
      const Color(0xFF22D3EE),
    ];

    final center = Offset(
      size.width * (0.5 + 0.15 * sin(2 * pi * t)),
      size.height * (0.5 + 0.15 * cos(2 * pi * t)),
    );

    final gradient = RadialGradient(
      center: Alignment(center.dx / size.width * 2 - 1, center.dy / size.height * 2 - 1),
      radius: 1.4,
      colors: colors,
      stops: [0.0, 0.45, 0.78, 1.0],
    );

    final bg = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, bg);

    // Floating translucent blobs
    void blob(Offset base, double r, Color c, double phase) {
      final p = Paint()
        ..color = c.withOpacity(0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 48);
      final dx = 40 * sin(2 * pi * (t + phase));
      final dy = 40 * cos(2 * pi * (t + phase));
      canvas.drawCircle(base + Offset(dx, dy), r, p);
    }

    blob(Offset(size.width * 0.2, size.height * 0.3), 120, Colors.white, 0.0);
    blob(Offset(size.width * 0.85, size.height * 0.25), 100, Colors.white, 0.25);
    blob(Offset(size.width * 0.75, size.height * 0.8), 140, Colors.white, 0.5);
    blob(Offset(size.width * 0.25, size.height * 0.75), 110, Colors.white, 0.75);

    // Very subtle grain
    final noise = Paint()..color = Colors.black.withOpacity(0.03);
    for (double y = 0; y < size.height; y += 3) {
      for (double x = 0; x < size.width; x += 3) {
        if ((x + y + t * 400) % 17 < 1) {
          canvas.drawRect(Rect.fromLTWH(x, y, 1, 1), noise);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _LuxuryPainter oldDelegate) => oldDelegate.t != t;
}
