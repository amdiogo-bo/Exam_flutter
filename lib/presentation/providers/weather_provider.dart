import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/weather_model.dart';
import '../../data/repositories/weather_repository.dart';
import '../../core/utils/result.dart';

/// État du chargement météo
class WeatherState {
  final bool isLoading;
  final List<WeatherModel> weatherList;
  final String? error;
  final double progress; // 0.0 à 1.0
  final String? currentLoadingCity;
  final bool isComplete;

  const WeatherState({
    this.isLoading = false,
    this.weatherList = const [],
    this.error,
    this.progress = 0.0,
    this.currentLoadingCity,
    this.isComplete = false,
  });

  WeatherState copyWith({
    bool? isLoading,
    List<WeatherModel>? weatherList,
    String? error,
    double? progress,
    String? currentLoadingCity,
    bool? isComplete,
    bool clearError = false,
  }) {
    return WeatherState(
      isLoading: isLoading ?? this.isLoading,
      weatherList: weatherList ?? this.weatherList,
      error: clearError ? null : (error ?? this.error),
      progress: progress ?? this.progress,
      currentLoadingCity: currentLoadingCity ?? this.currentLoadingCity,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}

/// Notifier principal pour la météo
class WeatherNotifier extends StateNotifier<WeatherState> {
  final WeatherRepository _repository;

  WeatherNotifier()
      : _repository = WeatherRepository(),
        super(const WeatherState());

  /// Déclenche le chargement de toutes les villes avec mise à jour de la progression
  Future<void> fetchAllCities() async {
    state = const WeatherState(isLoading: true, progress: 0.0);

    const cities = ['Paris', 'Dakar', 'New York', 'Tokyo', 'London'];
    final models = <WeatherModel>[];
    String? lastError;

    for (int i = 0; i < cities.length; i++) {
      final city = cities[i];

      // Mettre à jour la ville en cours de chargement
      state = state.copyWith(
        currentLoadingCity: city,
        progress: i / cities.length,
      );

      // Délai pour simuler le chargement progressif (synchronisé avec la jauge)
      await Future.delayed(const Duration(milliseconds: 500));

      final result = await _repository.getWeather(city);

      switch (result) {
        case Success(:final data):
          models.add(data);
        case Failure(:final message):
          lastError = message;
          debugPrint('Erreur pour $city: $message');
      }

      // Mise à jour de la progression
      state = state.copyWith(
        progress: (i + 1) / cities.length,
        weatherList: List.from(models),
      );
    }

    // État final
    if (models.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        error: lastError,
        isComplete: false,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        isComplete: true,
        progress: 1.0,
        error: lastError,
      );
    }
  }

  /// Réessayer le chargement
  Future<void> retry() async {
    state = const WeatherState();
    await fetchAllCities();
  }

  /// Réinitialiser l'état pour recommencer
  void reset() {
    state = const WeatherState();
  }
}


/// Provider principal pour la météo
final weatherProvider =
    StateNotifierProvider<WeatherNotifier, WeatherState>((ref) {
  return WeatherNotifier();
});

/// Provider pour la ville sélectionnée (navigation vers détail)
final selectedCityProvider = StateProvider<WeatherModel?>((ref) => null);
