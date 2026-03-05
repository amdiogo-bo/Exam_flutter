 Exam Flutter — Application Météo

Projet réalisé dans le cadre de l'examen de Développement 

Membres du groupe : Amadou Diogo Ba, Mamadou François Toure, Awa Ndao

---

C'est quoi l'appli ?

Une application Flutter qui affiche la météo en temps réel pour 5 villes dans le monde. On a utilisé l'API OpenWeatherMap pour récupérer les données et flutter_map pour afficher la carte.

---

 Ce qu'on a fait

- Un écran d'accueil avec une animation et un bouton pour démarrer
- Un écran de chargement avec une jauge qui se remplit pendant qu'on charge les données des 5 villes
- Des messages qui tournent pendant le chargement (genre "presque fini..." etc)
- Un écran résultats qui liste les 5 villes avec leur température, humidité, vent
- En cliquant sur une ville on voit les détails + sa position sur une carte interactive
- Le mode sombre et clair qu'on peut changer à tout moment
- Gestion des erreurs si l'API répond pas, avec un bouton pour réessayer

---

 Installation

Cloner le projet :

git clone <lien_github>
cd Exam_flutter


Installer les dépendances :
flutter pub get


Mettre votre clé API OpenWeatherMap dans `lib/data/services/weather_api_service.dart` :
static const String _apiKey = 'VOTRE_CLE_ICI';


Lancer :
flutter run




 Ce qu'on a utilisé

- Flutter + Dart pour tout le front
- Riverpod pour gérer l'état de l'appli
- Dio + Retrofit pour les appels API
- flutter_map pour la carte (OpenStreetMap, gratuit sans clé)
- animated_text_kit pour les messages animés
- google_fonts pour les polices

---

 Structure du projet


lib/
├── main.dart
├── core/          : couleurs, thème, réseau, utilitaires
├── data/          : modèles, repository, service API
└── presentation/  : écrans, providers, widgets


