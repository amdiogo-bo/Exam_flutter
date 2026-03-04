import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:retrofit/retrofit.dart';
import '../models/weather_model.dart';
import '../../core/network/api_client.dart';
import '../../core/network/network_exceptions.dart';
import '../../core/utils/result.dart';

part 'weather_api_service.g.dart';

/// Service Retrofit pour les appels API OpenWeatherMap
@RestApi(baseUrl: 'https://api.openweathermap.org/data/2.5/')
abstract class WeatherApiService {
  factory WeatherApiService(Dio dio, {String baseUrl}) = _WeatherApiService;

  /// Récupère la météo d'une ville par son nom
  @GET('weather')
  Future<Map<String, dynamic>> getWeatherByCity(
    @Query('q') String cityName,
    @Query('appid') String apiKey,
    @Query('units') String units,
    @Query('lang') String lang,
  );
}

/// Wrapper pour utiliser le service avec gestion d'erreurs
class WeatherApiClient {
  final WeatherApiService _service;

  // ⚠️ Remplacez cette clé par votre clé API OpenWeatherMap
  static const String _apiKey = 'VOTRE_CLE_API_OPENWEATHERMAP';
  static const String _units = 'metric';
  static const String _lang = 'fr';

  WeatherApiClient() : _service = WeatherApiService(ApiClient.createDio());

  /// Récupère la météo d'une ville avec gestion d'erreurs
  Future<Result<WeatherModel>> fetchWeather(String cityName) async {
    try {
      debugPrint('Fetching weather for: $cityName');
      final response = await _service.getWeatherByCity(
        cityName,
        _apiKey,
        _units,
        _lang,
      );
      final model = WeatherModel.fromApiJson(response);
      debugPrint('Weather fetched successfully for: ${model.cityName}');
      return Success(model);
    } catch (e) {
      final message = NetworkExceptions.getErrorMessage(e);
      debugPrint('Error fetching weather for $cityName: $message');
      return Failure(message, exception: e is Exception ? e : Exception(e.toString()));
    }
  }
}
