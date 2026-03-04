class AppStrings {
  AppStrings._();
  static const String appName    = 'WeatherApp';
  static const String splashTitle = 'WeatherApp';
  static const String splashSubtitle = 'Météo mondiale en temps réel';
  static const String splashButton = 'Explorer la météo';
  static const String loadingTitle = 'Synchronisation';
  static const String loadingCity  = '';
  static const List<String> loadingMessages = [
    'Connexion aux satellites météo… 🛰',
    'Analyse des données atmosphériques… 🌡',
    'Traitement en cours… ⚡',
    'Presque terminé… ✨',
  ];
  static const String loadingComplete  = 'Voir les résultats';
  static const String resultsTitle     = 'Météo Mondiale';
  static const String resultsLastUpdate = 'Mis à jour ';
  static const String resultsRestart   = 'Actualiser';
  static const String detailFeelsLike  = 'Ressenti';
  static const String detailTempMin    = 'Min';
  static const String detailTempMax    = 'Max';
  static const String detailHumidity   = 'Humidité';
  static const String detailPressure   = 'Pression';
  static const String detailWind       = 'Vent';
  static const String detailVisibility = 'Visibilité';
  static const String detailSunrise    = 'Lever';
  static const String detailSunset     = 'Coucher';
  static const String errorNoConnection  = 'Pas de connexion réseau 📵';
  static const String errorAuth          = 'Clé API invalide';
  static const String errorCityNotFound  = 'Ville introuvable';
  static const String errorTimeout       = 'Délai dépassé ⏱';
  static const String errorServer        = 'Serveur indisponible';
  static const String errorUnknown       = 'Erreur inconnue';
  static const String errorRetry         = 'Réessayer';
  static const List<String> cities = ['Paris','Dakar','New York','Tokyo','London'];
}
