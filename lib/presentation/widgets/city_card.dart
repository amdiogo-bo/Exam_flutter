import 'package:flutter/material.dart';
import '../../data/models/weather_model.dart';
import '../../core/constants/app_colors.dart';

/// Carte ville cliquable utilisable de manière standalone
class StandaloneCityCard extends StatelessWidget {
  final WeatherModel weather;
  final VoidCallback onTap;

  const StandaloneCityCard({
    super.key,
    required this.weather,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tempColor = AppColors.temperatureColor(weather.temperature);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              tempColor.withValues(alpha: 0.2),
              theme.colorScheme.surface,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: tempColor.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: tempColor.withValues(alpha: 0.3),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Image.network(
                weather.iconUrl,
                width: 60,
                height: 60,
                errorBuilder: (_, __, ___) =>
                const Icon(Icons.cloud, size: 60),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${weather.cityName}, ${weather.country}',
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(
                      weather.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${weather.temperature.toStringAsFixed(0)}°C',
                style: theme.textTheme.displayMedium?.copyWith(
                  color: tempColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
