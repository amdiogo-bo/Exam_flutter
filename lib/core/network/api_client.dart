import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;

/// Configuration Dio pour les appels API OpenWeatherMap
class ApiClient {
  ApiClient._();

  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/';
  static const int timeoutSeconds = 10;

  /// Instance Dio configurée avec intercepteurs et timeouts
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: timeoutSeconds),
        receiveTimeout: const Duration(seconds: timeoutSeconds),
        sendTimeout: const Duration(seconds: timeoutSeconds),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Intercepteur pour logger les requêtes en mode debug
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: false,
        requestBody: false,
        responseHeader: false,
        responseBody: true,
        error: true,
        logPrint: (log) => debugPrint('[ApiClient] ${log.toString()}'),
      ),
    );

    return dio;
  }
}
