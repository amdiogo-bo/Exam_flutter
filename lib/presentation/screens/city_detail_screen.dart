import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/weather_model.dart';
import '../providers/weather_provider.dart';
import '../providers/theme_provider.dart';

class CityDetailScreen extends ConsumerStatefulWidget {
  const CityDetailScreen({super.key});
  @override
  ConsumerState<CityDetailScreen> createState() => _CityDetailScreenState();
}

class _CityDetailScreenState extends ConsumerState<CityDetailScreen> {
  final MapController _mapCtrl = MapController();
  @override
  void dispose() { _mapCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final city   = ref.watch(selectedCityProvider);
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    if (city == null) {
      return Scaffold(appBar: AppBar(), body: const Center(child: Text('Aucune ville')));
    }

    final tColor = AppColors.temperatureColor(city.temperature);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: CustomScrollView(slivers: [
        // ── AppBar colorée ───────────────────────────────
        SliverAppBar(
          expandedHeight: 220,
          pinned: true,
          backgroundColor: isDark ? AppColors.darkBg : tColor,
          foregroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(children: [
              // Fond dégradé avec couleur température
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isDark
                        ? [tColor.withValues(alpha: 0.4), AppColors.darkBg]
                        : [tColor, tColor.withValues(alpha: 0.6)],
                  ),
                ),
              ),
              // Contenu header
              SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.7, end: 1.0),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.elasticOut,
                      builder: (_, v, child) => Transform.scale(scale: v, child: child),
                      child: Image.network(
                        city.iconUrl, width: 80, height: 80,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.cloud, size: 80, color: Colors.white),
                      ),
                    ),
                    Text(
                      '${city.temperature.toStringAsFixed(1)}°C',
                      style: GoogleFonts.outfit(
                        fontSize: 52, fontWeight: FontWeight.w800,
                        color: Colors.white, height: 1.1,
                      ),
                    ),
                    Text(
                      city.description.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 13, letterSpacing: 3,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
            title: Hero(
              tag: 'city_${city.cityName}',
              child: Material(
                type: MaterialType.transparency,
                child: Text(
                  '${city.cityName}, ${city.country}',
                  style: GoogleFonts.outfit(
                    fontSize: 18, fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
          ),
        ),

        // ── Corps ────────────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(delegate: SliverChildListDelegate([
            // Grille infos
            _InfoGrid(city: city, isDark: isDark),
            const SizedBox(height: 16),

            // Lever/coucher
            _SunCard(city: city, isDark: isDark),
            const SizedBox(height: 16),

            // Carte OSM
            _MapCard(city: city, mapCtrl: _mapCtrl, isDark: isDark),
            const SizedBox(height: 32),
          ])),
        ),
      ]),
    );
  }
}

// ── Grille des infos météo ──────────────────────────────
class _InfoGrid extends StatelessWidget {
  final WeatherModel city;
  final bool isDark;
  const _InfoGrid({required this.city, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final items = [
      _Info(Icons.thermostat_rounded, AppStrings.detailFeelsLike,
          '${city.feelsLike.toStringAsFixed(1)}°C', AppColors.aurora4),
      _Info(Icons.arrow_downward_rounded, AppStrings.detailTempMin,
          '${city.tempMin.toStringAsFixed(1)}°C', AppColors.aurora2),
      _Info(Icons.arrow_upward_rounded, AppStrings.detailTempMax,
          '${city.tempMax.toStringAsFixed(1)}°C', AppColors.aurora5),
      _Info(Icons.water_drop_rounded, AppStrings.detailHumidity,
          '${city.humidity}%', AppColors.aurora2),
      _Info(Icons.compress_rounded, AppStrings.detailPressure,
          '${city.pressure} hPa', AppColors.aurora3),
      _Info(Icons.air_rounded, AppStrings.detailWind,
          '${city.windSpeed.toStringAsFixed(1)} m/s', AppColors.aurora1),
      _Info(Icons.visibility_rounded, AppStrings.detailVisibility,
          '${(city.visibility/1000).toStringAsFixed(1)} km', AppColors.aurora3),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, childAspectRatio: 2.1,
        crossAxisSpacing: 12, mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (ctx, i) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: Duration(milliseconds: 300 + i * 70),
        curve: Curves.easeOut,
        builder: (_, v, child) => Opacity(
          opacity: v,
          child: Transform.translate(offset: Offset(0, 16*(1-v)), child: child),
        ),
        child: _InfoTile(info: items[i], isDark: isDark),
      ),
    );
  }
}

class _Info {
  final IconData icon;
  final String label, value;
  final Color color;
  const _Info(this.icon, this.label, this.value, this.color);
}

class _InfoTile extends StatelessWidget {
  final _Info info;
  final bool isDark;
  const _InfoTile({required this.info, required this.isDark});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: info.color.withValues(alpha: 0.2), width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? info.color.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 12, offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: info.color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(info.icon, color: info.color, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(info.label, style: GoogleFonts.inter(
              fontSize: 11,
              color: isDark
                  ? AppColors.darkTextSub
                  : AppColors.lightText.withValues(alpha: 0.55),
            )),
            Text(info.value, style: GoogleFonts.outfit(
              fontSize: 14, fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            )),
          ],
        )),
      ]),
    );
  }
}

// ── Carte soleil ────────────────────────────────────────
class _SunCard extends StatelessWidget {
  final WeatherModel city;
  final bool isDark;
  const _SunCard({required this.city, required this.isDark});
  String _fmt(int ts) {
    final d = DateTime.fromMillisecondsSinceEpoch(ts * 1000);
    return '${d.hour.toString().padLeft(2,'0')}:${d.minute.toString().padLeft(2,'0')}';
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.aurora4.withValues(alpha: 0.2),
        ),
      ),
      child: Row(children: [
        Expanded(child: Column(children: [
          const Text('🌅', style: TextStyle(fontSize: 32)),
          const SizedBox(height: 6),
          Text(AppStrings.detailSunrise, style: GoogleFonts.inter(
            fontSize: 12,
            color: isDark ? AppColors.darkTextSub : AppColors.lightText.withValues(alpha: 0.55),
          )),
          Text(_fmt(city.sunrise), style: GoogleFonts.outfit(
            fontSize: 20, fontWeight: FontWeight.w700,
            color: AppColors.aurora4,
          )),
        ])),
        Container(width: 1, height: 60,
            color: isDark ? Colors.white12 : Colors.black12),
        Expanded(child: Column(children: [
          const Text('🌇', style: TextStyle(fontSize: 32)),
          const SizedBox(height: 6),
          Text(AppStrings.detailSunset, style: GoogleFonts.inter(
            fontSize: 12,
            color: isDark ? AppColors.darkTextSub : AppColors.lightText.withValues(alpha: 0.55),
          )),
          Text(_fmt(city.sunset), style: GoogleFonts.outfit(
            fontSize: 20, fontWeight: FontWeight.w700,
            color: const Color(0xFFFF6B35),
          )),
        ])),
      ]),
    );
  }
}

// ── Carte OpenStreetMap ─────────────────────────────────
class _MapCard extends StatelessWidget {
  final WeatherModel city;
  final MapController mapCtrl;
  final bool isDark;
  const _MapCard({required this.city, required this.mapCtrl, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final pos    = LatLng(city.latitude, city.longitude);
    final tColor = AppColors.temperatureColor(city.temperature);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.aurora2.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? AppColors.aurora2.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.06),
            blurRadius: 20, offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // En-tête carte
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Row(children: [
            Icon(Icons.map_rounded, color: AppColors.aurora2, size: 20),
            const SizedBox(width: 8),
            Text('Localisation', style: GoogleFonts.outfit(
              fontSize: 16, fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            )),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.aurora1.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.aurora1.withValues(alpha: 0.4)),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.public, size: 11, color: AppColors.aurora1),
                const SizedBox(width: 4),
                Text('OpenStreetMap', style: GoogleFonts.inter(
                  fontSize: 10, fontWeight: FontWeight.w700,
                  color: AppColors.aurora1,
                )),
              ]),
            ),
          ]),
        ),

        // Carte
        SizedBox(
          height: 280,
          child: FlutterMap(
            mapController: mapCtrl,
            options: MapOptions(
              initialCenter: pos,
              initialZoom: 10.0,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.weather_app',
                maxZoom: 19,
              ),
              MarkerLayer(markers: [
                Marker(
                  point: pos, width: 90, height: 70,
                  child: Column(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: tColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: tColor.withValues(alpha: 0.5),
                            blurRadius: 10, spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Text(
                        '${city.temperature.toStringAsFixed(0)}°C',
                        style: GoogleFonts.outfit(
                          fontSize: 13, fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Icon(Icons.location_pin, color: tColor, size: 32),
                  ]),
                ),
              ]),
            ],
          ),
        ),

        // Coordonnées
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            Icon(Icons.gps_fixed, size: 13,
                color: isDark ? AppColors.darkTextSub : AppColors.lightText.withValues(alpha: 0.4)),
            const SizedBox(width: 6),
            Text(
              'Lat: ${city.latitude.toStringAsFixed(4)}, Lon: ${city.longitude.toStringAsFixed(4)}',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: isDark
                    ? AppColors.darkTextSub
                    : AppColors.lightText.withValues(alpha: 0.4),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}
