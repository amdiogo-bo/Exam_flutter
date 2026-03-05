part of 'weather_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherModel _$WeatherModelFromJson(Map<String, dynamic> json) => WeatherModel(
      cityName: json['name'] as String,
      country: json['country'] as String,
      temperature: (json['temperature'] as num).toDouble(),
      feelsLike: (json['feelsLike'] as num).toDouble(),
      tempMin: (json['tempMin'] as num).toDouble(),
      tempMax: (json['tempMax'] as num).toDouble(),
      humidity: json['humidity'] as int,
      windSpeed: (json['windSpeed'] as num).toDouble(),
      description: json['description'] as String,
      iconCode: json['iconCode'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      sunrise: json['sunrise'] as int,
      sunset: json['sunset'] as int,
      pressure: json['pressure'] as int,
      visibility: json['visibility'] as int,
    );

Map<String, dynamic> _$WeatherModelToJson(WeatherModel instance) =>
    <String, dynamic>{
      'name': instance.cityName,
      'country': instance.country,
      'temperature': instance.temperature,
      'feelsLike': instance.feelsLike,
      'tempMin': instance.tempMin,
      'tempMax': instance.tempMax,
      'humidity': instance.humidity,
      'windSpeed': instance.windSpeed,
      'description': instance.description,
      'iconCode': instance.iconCode,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'sunrise': instance.sunrise,
      'sunset': instance.sunset,
      'pressure': instance.pressure,
      'visibility': instance.visibility,
    };
