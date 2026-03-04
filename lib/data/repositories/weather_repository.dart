import '../models/weather_model.dart';
import '../services/weather_api_service.dart';
import '../../core/utils/result.dart';
import '../../core/constants/app_strings.dart';

/// Interface abstraite du repository météo
abstract class IWeatherRepository {
  Future<Result<WeatherModel>> getWeather(String cityName);
  Future<Result<List<WeatherModel>>> getAllCitiesWeather();
}

/// Implémentation concrète du repository météo
class WeatherRepository implements IWeatherRepository {
  final WeatherApiClient _apiClient;

  WeatherRepository() : _apiClient = WeatherApiClient();

  @override
  Future<Result<WeatherModel>> getWeather(String cityName) async {
    return _apiClient.fetchWeather(cityName);
  }

  /// Récupère la météo pour toutes les villes configurées en parallèle
  @override
  Future<Result<List<WeatherModel>>> getAllCitiesWeather() async {
    try {
      // Lancer tous les appels API en parallèle avec Future.wait
      final futures = AppStrings.cities
          .map((city) => _apiClient.fetchWeather(city))
          .toList();

      final results = await Future.wait(futures);

      // Séparer les succès des échecs
      final models = <WeatherModel>[];
      final errors = <String>[];

      for (int i = 0; i < results.length; i++) {
        final result = results[i];
        switch (result) {
          case Success(:final data):
            models.add(data);
          case Failure(:final message):
            errors.add('${AppStrings.cities[i]}: $message');
        }
      }

      // Si au moins une ville a réussi, on retourne les résultats
      if (models.isNotEmpty) {
        return Success(models);
      }

      // Toutes les villes ont échoué
      return Failure(errors.join(', '));
    } catch (e) {
      return Failure(AppStrings.errorUnknown, exception: e is Exception ? e : Exception(e.toString()));
    }
  }
}
