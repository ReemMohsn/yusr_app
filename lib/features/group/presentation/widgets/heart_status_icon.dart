import 'package:flutter/material.dart';

/// A small heart icon with an ECG/heartbeat line drawn with CustomPaint.
/// [color] determines the health status:
///   • AppColor.success  → good
///   • Color(0xFFF59E0B) → pending/warning
class HeartStatusIcon extends StatelessWidget {
  final Color color;

  const HeartStatusIcon({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16,
      height: 16,
      child: CustomPaint(painter: _HeartPainter(color: color)),
    );
  }
}

class _HeartPainter extends CustomPainter {
  final Color color;

  const _HeartPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.66667
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // ── Heart outline ──
    final heartPath = Path()
      ..moveTo(size.width * 0.0833, size.height * 0.3958)
      ..cubicTo(size.width * 0.0833, size.height * 0.3494, size.width * 0.0974,
          size.height * 0.3042, size.width * 0.1237, size.height * 0.2660)
      ..cubicTo(size.width * 0.1499, size.height * 0.2278, size.width * 0.1872,
          size.height * 0.1984, size.width * 0.2305, size.height * 0.1819)
      ..cubicTo(size.width * 0.2738, size.height * 0.1653, size.width * 0.3211,
          size.height * 0.1622, size.width * 0.3662, size.height * 0.1730)
      ..cubicTo(size.width * 0.4112, size.height * 0.1840, size.width * 0.4520,
          size.height * 0.2082, size.width * 0.4830, size.height * 0.2427)
      ..cubicTo(size.width * 0.5, size.height * 0.25, size.width * 0.5,
          size.height * 0.25, size.width * 0.5, size.height * 0.2506)
      ..cubicTo(size.width * 0.5480, size.height * 0.2080, size.width * 0.5887,
          size.height * 0.1835, size.width * 0.6338, size.height * 0.1725)
      ..cubicTo(size.width * 0.6790, size.height * 0.1615, size.width * 0.7264,
          size.height * 0.1645, size.width * 0.7698, size.height * 0.1815)
      ..cubicTo(size.width * 0.8132, size.height * 0.1978, size.width * 0.8505,
          size.height * 0.2273, size.width * 0.8767, size.height * 0.2658)
      ..cubicTo(size.width * 0.9030, size.height * 0.3018, size.width * 0.9169,
          size.height * 0.3687, size.width * 0.9167, size.height * 0.3958)
      ..cubicTo(size.width * 0.9167, size.height * 0.4913, size.width * 0.8542,
          size.height * 0.5625, size.width * 0.7917, size.height * 0.6250)
      ..lineTo(size.width * 0.5628, size.height * 0.8464)
      ..cubicTo(size.width * 0.5, size.height * 0.9167, size.width * 0.5,
          size.height * 0.9167, size.width * 0.5, size.height * 0.8750)
      ..lineTo(size.width * 0.2083, size.height * 0.6250)
      ..cubicTo(size.width * 0.1458, size.height * 0.5625, size.width * 0.0833,
          size.height * 0.4917, size.width * 0.0833, size.height * 0.3958)
      ..close();
    canvas.drawPath(heartPath, paint);

    // ── ECG line ──
    final linePath = Path()
      ..moveTo(size.width * 0.1342, size.height * 0.5417)
      ..lineTo(size.width * 0.3958, size.height * 0.5417)
      ..lineTo(size.width * 0.4167, size.height * 0.5000)
      ..lineTo(size.width * 0.5000, size.height * 0.6875)
      ..lineTo(size.width * 0.5833, size.height * 0.3958)
      ..lineTo(size.width * 0.6458, size.height * 0.5417)
      ..lineTo(size.width * 0.8654, size.height * 0.5417);
    canvas.drawPath(linePath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
