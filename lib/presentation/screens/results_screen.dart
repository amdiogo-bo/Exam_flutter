import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/weather_model.dart';
import '../providers/weather_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/error_widget.dart';
import 'loading_screen.dart';
import 'city_detail_screen.dart';

class ResultsScreen extends ConsumerWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state  = ref.watch(weatherProvider);
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final theme  = Theme.of(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: CustomScrollView(
        slivers: [
          //AppBar flottant style aurora
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: isDark ? AppColors.darkBg : AppColors.lightPrimary,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 14),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (b) => const LinearGradient(
                      colors: [AppColors.aurora2, AppColors.aurora1],
                    ).createShader(b),
                    child: Text(
                      'MÉTÉO MONDIALE',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  Text(
                    '${AppStrings.resultsLastUpdate}${_time()}',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: Colors.white.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                    colors: isDark
                        ? [AppColors.darkBg2, AppColors.darkBg]
                        : [AppColors.lightPrimary, const Color(0xFF0288D1)],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.refresh_rounded,
                    color: isDark ? AppColors.aurora2 : Colors.white),
                onPressed: () => ref.read(weatherProvider.notifier).fetchAllCities(),
              ),
              IconButton(
                icon: Icon(
                  isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                  color: isDark ? AppColors.aurora1 : Colors.white,
                ),
                onPressed: () {
                  final cur = ref.read(themeModeProvider);
                  ref.read(themeModeProvider.notifier).state =
                  cur == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
                },
              ),
              const SizedBox(width: 8),
            ],
          ),

          //  Corps
          if (state.isLoading && state.weatherList.isEmpty)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(
                color: AppColors.aurora2,
              )),
            )
          else if (state.weatherList.isEmpty && state.error != null)
            SliverFillRemaining(
              child: AppErrorWidget(
                message: state.error!,
                onRetry: () => ref.read(weatherProvider.notifier).retry(),
              ),
            )
          else ...[
              if (state.error != null)
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.warning.withValues(alpha: 0.4)),
                    ),
                    child: Row(children: [
                      const Icon(Icons.warning_amber_rounded,
                          color: AppColors.warning, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Chargement partiel : ${state.error}',
                          style: GoogleFonts.inter(
                            fontSize: 12, color: AppColors.warning,
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),

              // Liste des villes
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (ctx, i) => _AuroraCityTile(
                      weather: state.weatherList[i],
                      index: i,
                      isDark: isDark,
                      onTap: () {
                        ref.read(selectedCityProvider.notifier).state =
                        state.weatherList[i];
                        Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, a, __) => const CityDetailScreen(),
                          transitionsBuilder: (_, a, __, child) =>
                              SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(1, 0), end: Offset.zero,
                                ).animate(CurvedAnimation(
                                  parent: a, curve: Curves.easeOutCubic,
                                )),
                                child: child,
                              ),
                          transitionDuration: const Duration(milliseconds: 350),
                        ));
                      },
                    ),
                    childCount: state.weatherList.length,
                  ),
                ),
              ),
            ],
        ],
      ),

      // FAB recommencer → retour à l'accueil (Splash) puis relance
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: const LinearGradient(
            colors: [AppColors.aurora2, AppColors.aurora1],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.aurora2.withValues(alpha: 0.5),
              blurRadius: 20,
              spreadRadius: 1,
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            ref.read(weatherProvider.notifier).reset();
            // revient au Splash, respecte le Back du sujet
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          icon: const Icon(Icons.restart_alt_rounded, color: AppColors.darkBg),
          label: Text(
            AppStrings.resultsRestart,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w700, color: AppColors.darkBg,
            ),
          ),
        ),
      ),
    );
  }

  String _time() {
    final n = DateTime.now();
    return '${n.hour.toString().padLeft(2,'0')}:${n.minute.toString().padLeft(2,'0')}';
  }
}

/// Carte ville style Aurora glassmorphism
class _AuroraCityTile extends StatefulWidget {
  final WeatherModel weather;
  final int index;
  final bool isDark;
  final VoidCallback onTap;

  const _AuroraCityTile({
    required this.weather,
    required this.index,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_AuroraCityTile> createState() => _AuroraCityTileState();
}

class _AuroraCityTileState extends State<_AuroraCityTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      duration: const Duration(milliseconds: 500), vsync: this,
    );
    _fade  = CurvedAnimation(parent: _c, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _c, curve: Curves.easeOutCubic));
    Future.delayed(Duration(milliseconds: 80 * widget.index), () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final w      = widget.weather;
    final isDark = widget.isDark;
    final tColor = AppColors.temperatureColor(w.temperature);

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: isDark
                  ? AppColors.darkCard
                  : Colors.white,
              border: Border.all(
                color: tColor.withValues(alpha: 0.25),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? tColor.withValues(alpha: 0.12)
                      : Colors.black.withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Stack(children: [
                // Accent coloré gauche
                Positioned(
                  left: 0, top: 0, bottom: 0,
                  child: Container(
                    width: 4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [tColor, tColor.withValues(alpha: 0.3)],
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
                  child: Row(children: [
                    // Icône météo
                    Image.network(
                      w.iconUrl, width: 56, height: 56,
                      errorBuilder: (_, __, ___) =>
                      const Icon(Icons.cloud, size: 56),
                    ),
                    const SizedBox(width: 14),

                    // Infos
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Hero(
                              tag: 'city_${w.cityName}',
                              child: Material(
                                type: MaterialType.transparency,
                                child: Text(
                                  w.cityName,
                                  style: GoogleFonts.outfit(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? AppColors.darkText : AppColors.lightText,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: tColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                w.country,
                                style: GoogleFonts.inter(
                                  fontSize: 11, fontWeight: FontWeight.w700,
                                  color: tColor,
                                ),
                              ),
                            ),
                          ]),
                          const SizedBox(height: 4),
                          Text(
                            w.description,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: isDark
                                  ? AppColors.darkTextSub
                                  : AppColors.lightText.withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(children: [
                            _Chip('💧', '${w.humidity}%', isDark),
                            const SizedBox(width: 12),
                            _Chip('💨', '${w.windSpeed.toStringAsFixed(1)}m/s', isDark),
                          ]),
                        ],
                      ),
                    ),

                    // Température
                    Column(
                      children: [
                        Text(
                          '${w.temperature.toStringAsFixed(0)}°',
                          style: GoogleFonts.outfit(
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            color: tColor,
                            height: 1,
                          ),
                        ),
                        Text(
                          'C',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: tColor.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Icon(Icons.chevron_right_rounded,
                            color: isDark
                                ? AppColors.darkTextSub
                                : AppColors.lightText.withValues(alpha: 0.3),
                            size: 20),
                      ],
                    ),
                  ]),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String emoji, value;
  final bool isDark;
  const _Chip(this.emoji, this.value, this.isDark);
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Text(emoji, style: const TextStyle(fontSize: 12)),
      const SizedBox(width: 3),
      Text(
        value,
        style: GoogleFonts.inter(
          fontSize: 12, fontWeight: FontWeight.w500,
          color: isDark ? AppColors.darkTextSub : AppColors.lightText.withValues(alpha: 0.7),
        ),
      ),
    ]);
  }
}
