import 'package:flutter/material.dart';
import '../../data/models/weather_model.dart';
import '../../core/constants/app_colors.dart';

/// Tableau météo avec animation staggerée pour chaque ligne
class WeatherTable extends StatefulWidget {
  final List<WeatherModel> weatherList;
  final Function(WeatherModel) onCityTap;

  const WeatherTable({
    super.key,
    required this.weatherList,
    required this.onCityTap,
  });

  @override
  State<WeatherTable> createState() => _WeatherTableState();
}

class _WeatherTableState extends State<WeatherTable>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _controllers = List.generate(
      widget.weatherList.length,
          (i) => AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      ),
    );

    _fadeAnimations = _controllers
        .map((c) => Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: c, curve: Curves.easeIn),
    ))
        .toList();

    _slideAnimations = _controllers
        .map((c) => Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: c, curve: Curves.easeOut)))
        .toList();

    // Démarrer les animations avec un délai staggeré
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: 100 * i), () {
        if (mounted) _controllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.weatherList.length,
      itemBuilder: (context, index) {
        final weather = widget.weatherList[index];
        return FadeTransition(
          opacity: _fadeAnimations[index],
          child: SlideTransition(
            position: _slideAnimations[index],
            child: CityCard(
              weather: weather,
              onTap: () => widget.onCityTap(weather),
            ),
          ),
        );
      },
    );
  }
}

/// Carte individuelle pour une ville dans le tableau
class CityCard extends StatelessWidget {
  final WeatherModel weather;
  final VoidCallback onTap;

  const CityCard({
    super.key,
    required this.weather,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tempColor = AppColors.temperatureColor(weather.temperature);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icône météo
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  weather.iconUrl,
                  width: 56,
                  height: 56,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.cloud,
                    size: 56,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Infos ville
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nom de la ville + pays
                    Row(
                      children: [
                        Hero(
                          tag: 'city_${weather.cityName}',
                          child: Material(
                            type: MaterialType.transparency,
                            child: Text(
                              weather.cityName,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          weather.country,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Description météo
                    Text(
                      weather.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Humidité + Vent
                    Row(
                      children: [
                        _InfoChip(icon: '💧', value: '${weather.humidity}%'),
                        const SizedBox(width: 12),
                        _InfoChip(
                          icon: '💨',
                          value:
                          '${weather.windSpeed.toStringAsFixed(1)} m/s',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Température
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: tempColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: tempColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  '${weather.temperature.toStringAsFixed(0)}°C',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: tempColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Flèche
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String icon;
  final String value;

  const _InfoChip({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
