import 'dart:ui';
import 'package:flutter/material.dart';
import '../../application/income_chart_data.dart';
import 'dart:math';

class IncomeLineChart extends StatefulWidget {
  final List<IncomeChartPoint> fact;
  final List<IncomeChartPoint> plan;

  const IncomeLineChart({super.key, required this.fact, required this.plan});

  @override
  State<IncomeLineChart> createState() => _IncomeLineChartState();
}

class _IncomeLineChartState extends State<IncomeLineChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.forward(from: 0);
      }
    });
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
      builder: (_, __) {
        return CustomPaint(
          size: Size.infinite,
          painter: _PremiumChartPainter(
            widget.fact,
            widget.plan,
            _controller.value,
          ),
        );
      },
    );
  }
}

class _PremiumChartPainter extends CustomPainter {
  final List<IncomeChartPoint> fact;
  final List<IncomeChartPoint> plan;
  final double progress;

  _PremiumChartPainter(this.fact, this.plan, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    const padding = 16.0;

    final values = [...fact.map((e) => e.value), ...plan.map((e) => e.value)];
    if (values.isEmpty) return;

    final maxValue = values.reduce((a, b) => a > b ? a : b);
    if (maxValue <= 0) return;

    final width = size.width - padding * 2;
    final height = size.height - padding * 2;

    Offset point(int i, double value, int count) {
      final x = padding + (i / (count - 1)) * width;
      final y = padding + height - (value / maxValue) * height;
      return Offset(x, y);
    }

    drawSmoothSeries(
      canvas,
      size,
      plan,
      point,
      padding,
      baseColor: const Color(0xFF4C8DFF).withOpacity(0.35),
      glow: false,
    );

    drawSmoothSeries(
      canvas,
      size,
      fact,
      point,
      padding,
      baseColor: const Color(0xFF4C8DFF),
      glow: true,
      drawTodayDot: true,
    );
  }

  void drawSmoothSeries(
    Canvas canvas,
    Size size,
    List<IncomeChartPoint> data,
    Offset Function(int, double, int) point,
    double padding, {
    required Color baseColor,
    bool glow = false,
    bool drawTodayDot = false,
  }) {
    if (data.length < 2) return;

    final visible = (data.length * progress).clamp(1, data.length).toInt();

    final points = List.generate(
      visible,
      (i) => point(i, data[i].value, data.length),
    );

    // ── GLOW ─────────────────────────────
    if (glow) {
      final glowPaint = Paint()
        ..color = baseColor.withOpacity(0.35)
        ..strokeWidth = 8
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12)
        ..isAntiAlias = true;

      _drawPath(canvas, points, glowPaint);
    }

    // ── LINE (GRADIENT) ───────────────────
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [baseColor.withOpacity(1), baseColor.withOpacity(0.6)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    _drawPath(canvas, points, gradientPaint);

    // ── FILL ─────────────────────────────
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [baseColor.withOpacity(0.25), baseColor.withOpacity(0.05)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final fillPath = Path()
      ..moveTo(points.first.dx, size.height - padding)
      ..lineTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final cx = (p0.dx + p1.dx) / 2;

      fillPath.cubicTo(cx, p0.dy, cx, p1.dy, p1.dx, p1.dy);
    }

    fillPath
      ..lineTo(points.last.dx, size.height - padding)
      ..close();

    canvas.drawPath(fillPath, fillPaint);

    // ── TODAY DOT ────────────────────────
    if (drawTodayDot) {
      final p = points.last;
      final pulse = 1 + (0.15 * sin(progress * 3.14));

      canvas.drawCircle(
        p,
        8 * pulse,
        Paint()..color = baseColor.withOpacity(0.2),
      );

      canvas.drawCircle(p, 4, Paint()..color = baseColor);
    }
  }

  void _drawPath(Canvas canvas, List<Offset> points, Paint paint) {
    final path = Path()..moveTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final cx = (p0.dx + p1.dx) / 2;

      path.cubicTo(cx, p0.dy, cx, p1.dy, p1.dx, p1.dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PremiumChartPainter old) {
    return old.progress != progress || old.fact != fact || old.plan != plan;
  }
}
