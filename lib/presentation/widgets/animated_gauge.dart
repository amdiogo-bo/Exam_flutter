import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

class AnimatedGauge extends StatefulWidget {
  final double progress;
  final double size;
  final VoidCallback? onComplete;
  const AnimatedGauge({super.key, required this.progress, this.size = 200, this.onComplete});
  @override
  State<AnimatedGauge> createState() => _AnimatedGaugeState();
}

class _AnimatedGaugeState extends State<AnimatedGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  double _prev = 0.0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 700), vsync: this,
    );
    _anim = Tween<double>(begin: 0.0, end: widget.progress)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    _ctrl.forward();
  }

  @override
  void didUpdateWidget(AnimatedGauge old) {
    super.didUpdateWidget(old);
    if (old.progress != widget.progress) {
      _prev = _anim.value;
      _anim = Tween<double>(begin: _prev, end: widget.progress)
          .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
      _ctrl..reset()..forward();
      if (widget.progress >= 1.0) {
        _ctrl.forward().then((_) => widget.onComplete?.call());
      }
    }
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        final p = _anim.value;
        final color = AppColors.gaugeColor(p);
        final pct = (p * 100).toInt();
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(alignment: Alignment.center, children: [
            // Glow externe
            Container(
              width: widget.size + 24,
              height: widget.size + 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.25 * p),
                    blurRadius: 40,
                    spreadRadius: 8,
                  ),
                ],
              ),
            ),
            // Arc de progression
            CustomPaint(
              size: Size(widget.size, widget.size),
              painter: _AuroraGaugePainter(p, color),
            ),
            // Centre
            Column(mainAxisSize: MainAxisSize.min, children: [
              ShaderMask(
                shaderCallback: (b) => LinearGradient(
                  colors: [color, color.withValues(alpha: 0.7)],
                ).createShader(b),
                child: Text(
                  '$pct%',
                  style: GoogleFonts.outfit(
                    fontSize: widget.size * 0.21,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
              ),
              Text(
                pct < 100 ? 'chargement' : 'terminé ✓',
                style: GoogleFonts.inter(
                  fontSize: widget.size * 0.075,
                  color: color.withValues(alpha: 0.8),
                  letterSpacing: 1,
                ),
              ),
            ]),
          ]),
        );
      },
    );
  }
}

class _AuroraGaugePainter extends CustomPainter {
  final double progress;
  final Color color;
  _AuroraGaugePainter(this.progress, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 14;
    const stroke = 14.0;

    // Fond
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r),
      -math.pi / 2, 2 * math.pi, false,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.08)
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );

    // Arc coloré avec dégradé
    final shader = SweepGradient(
      startAngle: -math.pi / 2,
      endAngle: -math.pi / 2 + 2 * math.pi * progress,
      colors: [
        color.withValues(alpha: 0.7),
        color,
      ],
    ).createShader(Rect.fromCircle(center: c, radius: r));

    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..shader = shader
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_AuroraGaugePainter o) =>
      o.progress != progress || o.color != color;
}
