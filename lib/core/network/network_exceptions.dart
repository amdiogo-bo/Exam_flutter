import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import '../constants/app_strings.dart';

/// Gestion centralisée des erreurs réseau
class NetworkExceptions {
  NetworkExceptions._();

  /// Convertit une DioException en message lisible
  static String getErrorMessage(dynamic error) {
    if (error is DioException) {
      return _handleDioException(error);
    }
    debugPrint('Erreur inconnue: $error');
    return AppStrings.errorUnknown;
  }

  static String _handleDioException(DioException e) {
    debugPrint('DioException: ${e.type} - ${e.message}');

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return AppStrings.errorTimeout;

      case DioExceptionType.connectionError:
        return AppStrings.errorNoConnection;

      case DioExceptionType.badResponse:
        return _handleStatusCode(e.response?.statusCode);

      case DioExceptionType.cancel:
        return 'Requête annulée';

      default:
        return AppStrings.errorUnknown;
    }
  }

  static String _handleStatusCode(int? statusCode) {
    if (statusCode == null) return AppStrings.errorUnknown;

    switch (statusCode) {
      case 401:
        return AppStrings.errorAuth;
      case 404:
        return AppStrings.errorCityNotFound;
      case 429:
        return 'Limite de requêtes atteinte';
      default:
        if (statusCode >= 500) return AppStrings.errorServer;
        return AppStrings.errorUnknown;
    }
  }
}
