import 'dart:math' as math;

import 'package:flutter/material.dart';

class PieChartData {
  final String label;
  final double value;
  final Color color;

  PieChartData({required this.label, required this.value, required this.color});
}

class SimplePieChart extends StatelessWidget {
  final List<PieChartData> data;
  final double size;
  final double strokeWidth;
  final bool showPercentage;

  const SimplePieChart({
    super.key,
    required this.data,
    this.size = 120,
    this.strokeWidth = 30,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    final total = data.fold<double>(0, (sum, item) => sum + item.value);

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _PieChartPainter(data: data, total: total, strokeWidth: strokeWidth),
        child: null,
      ),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final List<PieChartData> data;
  final double total;
  final double strokeWidth;

  _PieChartPainter({required this.data, required this.total, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    // Draw background circle
    final backgroundPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius - strokeWidth / 2, backgroundPaint);

    // Draw pie segments
    double startAngle = -math.pi / 2; // Start from top

    for (final segment in data) {
      final sweepAngle = (segment.value / total) * 2 * math.pi;

      final paint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(_PieChartPainter oldDelegate) {
    return oldDelegate.data != data || oldDelegate.total != total;
  }
}
