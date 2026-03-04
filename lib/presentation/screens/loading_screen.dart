import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../providers/weather_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/animated_gauge.dart';
import '../widgets/error_widget.dart';
import 'results_screen.dart';

class LoadingScreen extends ConsumerStatefulWidget {
  const LoadingScreen({super.key});
  @override
  ConsumerState<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends ConsumerState<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _btnCtrl;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _btnCtrl = AnimationController(
      duration: const Duration(milliseconds: 600), vsync: this,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(weatherProvider.notifier).fetchAllCities();
    });
  }

  @override
  void dispose() {
    _btnCtrl.dispose();
    super.dispose();
  }

  void _navigateToResults() {
    if (_hasNavigated) return;
    _hasNavigated = true;
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (_, a, __) => const ResultsScreen(),
      transitionsBuilder: (_, a, __, child) =>
          FadeTransition(opacity: a, child: child),
      transitionDuration: const Duration(milliseconds: 500),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final state  = ref.watch(weatherProvider);
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    if (state.isComplete && !_hasNavigated) {
      _btnCtrl.forward();
      Future.delayed(const Duration(milliseconds: 1500), _navigateToResults);
    }

    final bg1 = isDark ? AppColors.darkBg  : const Color(0xFF1565C0);
    final bg2 = isDark ? AppColors.darkBg2 : const Color(0xFF0288D1);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [bg1, bg2, bg1],
          ),
        ),
        child: state.error != null && state.weatherList.isEmpty
            ? AppErrorWidget(
          message: state.error!,
          onRetry: () {
            _hasNavigated = false;
            ref.read(weatherProvider.notifier).retry();
          },
        )
            : SafeArea(
          child: Column(children: [
            // ── Header ────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(children: [
                ShaderMask(
                  shaderCallback: (b) => const LinearGradient(
                    colors: [AppColors.aurora2, AppColors.aurora1],
                  ).createShader(b),
                  child: Text(
                    'SYNCHRONISATION',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 3,
                    ),
                  ),
                ),
              ]),
            ),

            const Spacer(),

            // ── Jauge ────────────────────────────────
            AnimatedGauge(
              progress: state.progress,
              size: 220,
              onComplete: () => _btnCtrl.forward(),
            ),

            const SizedBox(height: 32),

            // Ville en cours
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: state.currentLoadingCity != null
                  ? _CityBadge(
                key: ValueKey(state.currentLoadingCity),
                city: state.currentLoadingCity!,
              )
                  : const SizedBox(height: 36),
            ),

            const SizedBox(height: 28),

            // Messages rotatifs
            SizedBox(
              height: 50,
              child: AnimatedTextKit(
                repeatForever: true,
                animatedTexts: AppStrings.loadingMessages
                    .map((msg) => FadeAnimatedText(
                  msg,
                  duration: const Duration(milliseconds: 2500),
                  textStyle: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.7),
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ))
                    .toList(),
              ),
            ),

            const SizedBox(height: 20),

            // Pills villes chargées
            _CityProgressRow(weatherList: state.weatherList),

            const Spacer(),

            // Bouton résultats
            AnimatedBuilder(
              animation: _btnCtrl,
              builder: (_, child) => Opacity(
                opacity: _btnCtrl.value,
                child: Transform.scale(
                  scale: 0.85 + 0.15 * _btnCtrl.value,
                  child: child,
                ),
              ),
              child: state.isComplete
                  ? Padding(
                padding: const EdgeInsets.only(bottom: 48),
                child: GestureDetector(
                  onTap: _navigateToResults,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      gradient: const LinearGradient(
                        colors: [AppColors.aurora1, AppColors.aurora2],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.aurora1.withValues(alpha: 0.5),
                          blurRadius: 30,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.loadingComplete,
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
              )
                  : const SizedBox(height: 80),
            ),
          ]),
        ),
      ),
    );
  }
}

class _CityBadge extends StatelessWidget {
  final String city;
  const _CityBadge({super.key, required this.city});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Text(
        'Chargement : $city',
        style: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white.withValues(alpha: 0.9),
        ),
      ),
    );
  }
}

class _CityProgressRow extends StatelessWidget {
  final List weatherList;
  const _CityProgressRow({required this.weatherList});
  @override
  Widget build(BuildContext context) {
    const cities = AppStrings.cities;
    final loaded = weatherList.map((w) => w.cityName as String).toSet();
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: cities.length,
        itemBuilder: (_, i) {
          final city = cities[i];
          final done = loaded.any((c) =>
          c.toLowerCase().contains(city.toLowerCase()) ||
              city.toLowerCase().contains(c.toLowerCase()));
          return AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: done
                  ? AppColors.aurora1.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: done
                    ? AppColors.aurora1.withValues(alpha: 0.7)
                    : Colors.white.withValues(alpha: 0.15),
              ),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(
                done ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                size: 13,
                color: done ? AppColors.aurora1 : Colors.white38,
              ),
              const SizedBox(width: 5),
              Text(
                city,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: done ? FontWeight.w700 : FontWeight.w400,
                  color: done ? AppColors.aurora1 : Colors.white38,
                ),
              ),
            ]),
          );
        },
      ),
    );
  }
}
