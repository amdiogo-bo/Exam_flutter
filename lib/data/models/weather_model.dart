import 'package:json_annotation/json_annotation.dart';
part 'weather_model.g.dart';

/// Modèle de données météo pour une ville
/// Utilisé avec json_serializable pour la désérialisation JSON
@JsonSerializable()
class WeatherModel {
  @JsonKey(name: 'name')
  final String cityName;

  final String country;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final double windSpeed;
  final String description;
  final String iconCode;
  final double latitude;
  final double longitude;
  final int sunrise;
  final int sunset;
  final int pressure;
  final int visibility;

  const WeatherModel({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.iconCode,
    required this.latitude,
    required this.longitude,
    required this.sunrise,
    required this.sunset,
    required this.pressure,
    required this.visibility,
  });

  /// URL de l'icône météo OpenWeatherMap
  String get iconUrl =>
      'https://openweathermap.org/img/wn/$iconCode@2x.png';

  /// Désérialisation manuelle depuis la réponse JSON d'OpenWeatherMap
  /// car la structure JSON est imbriquée (main.temp, coord.lat, etc.)
  factory WeatherModel.fromApiJson(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>;
    final weather = (json['weather'] as List<dynamic>).first as Map<String, dynamic>;
    final wind = json['wind'] as Map<String, dynamic>;
    final coord = json['coord'] as Map<String, dynamic>;
    final sys = json['sys'] as Map<String, dynamic>;

    return WeatherModel(
      cityName: json['name'] as String,
      country: sys['country'] as String,
      temperature: (main['temp'] as num).toDouble(),
      feelsLike: (main['feels_like'] as num).toDouble(),
      tempMin: (main['temp_min'] as num).toDouble(),
      tempMax: (main['temp_max'] as num).toDouble(),
      humidity: main['humidity'] as int,
      windSpeed: (wind['speed'] as num).toDouble(),
      description: weather['description'] as String,
      iconCode: weather['icon'] as String,
      latitude: (coord['lat'] as num).toDouble(),
      longitude: (coord['lon'] as num).toDouble(),
      sunrise: sys['sunrise'] as int,
      sunset: sys['sunset'] as int,
      pressure: main['pressure'] as int,
      visibility: (json['visibility'] as int?) ?? 0,
    );
  }

  factory WeatherModel.fromJson(Map<String, dynamic> json) =>
      _$WeatherModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherModelToJson(this);

  @override
  String toString() => 'WeatherModel(city: $cityName, temp: $temperature°C)';
}
