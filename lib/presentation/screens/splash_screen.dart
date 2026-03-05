import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../providers/theme_provider.dart';
import 'loading_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});
  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _bgCtrl;
  late AnimationController _contentCtrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _bgCtrl = AnimationController(
      duration: const Duration(seconds: 8), vsync: this,
    )..repeat();
    _contentCtrl = AnimationController(
      duration: const Duration(milliseconds: 1000), vsync: this,
    );
    _fade = CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOutCubic));
    _contentCtrl.forward();
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  //le bouton Back Android ramène à l'accueil
  void _go() {
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (_, a, __) => const LoadingScreen(),
      transitionsBuilder: (_, a, __, child) =>
          FadeTransition(opacity: a, child: child),
      transitionDuration: const Duration(milliseconds: 500),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final size   = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(children: [
        //FOND aurora animé
        AnimatedBuilder(
          animation: _bgCtrl,
          builder: (_, __) => Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? const [Color(0xFF050B1A), Color(0xFF0D1F3C), Color(0xFF050B1A)]
                    : const [Color(0xFF1565C0), Color(0xFF0288D1), Color(0xFF1565C0)],
              ),
            ),
            child: CustomPaint(
              painter: _AuroraBgPainter(_bgCtrl.value, isDark),
            ),
          ),
        ),

        // ── Contenu ───────────────────────────────────────
        SafeArea(
          child: Column(children: [
            // Toggle thème
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: () => ref.toggleTheme(),
                  child: Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.15),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Icon(
                      isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                      color: isDark ? AppColors.aurora1 : Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),

            const Spacer(flex: 2),

            // Orbe centrale pulsante
            FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: _PulsingOrb(isDark: isDark),
              ),
            ),

            const SizedBox(height: 48),

            // Titre Aurora
            FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: Column(children: [
                  Text(
                    'SEN',
                    style: GoogleFonts.outfit(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 10,
                    ),
                  ),
                  ShaderMask(
                    shaderCallback: (b) => const LinearGradient(
                      colors: [AppColors.aurora2, AppColors.aurora1],
                    ).createShader(b),
                    child: Text(
                      'COSMOS',
                      style: GoogleFonts.outfit(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Météo mondiale en temps réel',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.7),
                      letterSpacing: 1.5,
                    ),
                  ),
                ]),
              ),
            ),

            const Spacer(flex: 3),

            // Bouton néon
            FadeTransition(
              opacity: _fade,
              child: GestureDetector(
                onTap: _go,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: const LinearGradient(
                      colors: [AppColors.aurora2, AppColors.aurora1],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.aurora2.withValues(alpha: 0.5),
                        blurRadius: 30,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Explorer la météo',
                        style: GoogleFonts.outfit(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkBg,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded,
                          color: AppColors.darkBg, size: 20),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            FadeTransition(
              opacity: _fade,
              child: Text(
                'Powered by OpenWeatherMap',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.35),
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ]),
        ),
      ]),
    );
  }
}

class _PulsingOrb extends StatefulWidget {
  final bool isDark;
  const _PulsingOrb({required this.isDark});
  @override
  State<_PulsingOrb> createState() => _PulsingOrbState();
}
class _PulsingOrbState extends State<_PulsingOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _s;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      duration: const Duration(seconds: 2), vsync: this,
    )..repeat(reverse: true);
    _s = Tween<double>(begin: 0.93, end: 1.07)
        .animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
  }
  @override
  void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _s,
      child: Container(
        width: 150, height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [
            AppColors.aurora2.withValues(alpha: 0.25),
            Colors.transparent,
          ]),
          border: Border.all(
            color: AppColors.aurora2.withValues(alpha: 0.6),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.aurora2.withValues(alpha: 0.35),
              blurRadius: 50,
              spreadRadius: 10,
            ),
          ],
        ),
        child: const Center(
          child: Text('🌍', style: TextStyle(fontSize: 70)),
        ),
      ),
    );
  }
}

class _AuroraBgPainter extends CustomPainter {
  final double t;
  final bool isDark;
  _AuroraBgPainter(this.t, this.isDark);
  @override
  void paint(Canvas canvas, Size size) {
    final blobs = isDark
        ? [AppColors.aurora3, AppColors.aurora2, AppColors.aurora1]
        : [Colors.white, Colors.lightBlueAccent, Colors.cyanAccent];
    for (int i = 0; i < blobs.length; i++) {
      final paint = Paint()
        ..color = blobs[i].withValues(alpha: isDark ? 0.1 : 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80);
      final off = math.sin((t + i * 0.33) * 2 * math.pi);
      canvas.drawCircle(
        Offset(
          size.width  * (0.25 + i * 0.25),
          size.height * (0.25 + off * 0.12),
        ),
        size.width * 0.45,
        paint,
      );
    }
  }
  @override
  bool shouldRepaint(_AuroraBgPainter o) => o.t != t;
}

