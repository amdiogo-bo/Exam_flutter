# 🌤 Exam_flutter — Application Flutter Météo Mondiale

Application Flutter complète de météo avec appels API en temps réel, animations, carte interactive et mode sombre/clair.

---

## 📱  Les membres du groupe : Amadou Diogo Ba & Mamadou François Toure & Awa Ndao

---

## 📱 Fonctionnalités

- **4 écrans** : Splash, Chargement, Résultats, Détail ville
- **Jauge animée** avec changement de couleur rouge → orange → vert
- **Appels API parallèles** vers OpenWeatherMap pour 5 villes
- **Carte Google Maps** avec marqueur personnalisé
- **Mode sombre/clair** avec bascule instantanée
- **Gestion d'erreurs complète** avec messages et bouton retry
- **Animations fluides** : FadeIn, SlideUp, Hero, Staggered list
- **Architecture MVVM + Clean** avec Riverpod

---

## 🚀 Installation

### 1. Cloner le projet

```bash
git clone <Exam_flutter>
cd Exam_flutter
```

### 2. Installer les dépendances

```bash
flutter pub get
```

### 3. Configurer votre clé API OpenWeatherMap

Obtenez une clé gratuite sur https://openweathermap.org/api

Dans le fichier `lib/data/services/weather_api_service.dart`, remplacez :

```dart
static const String _apiKey = '21671cbfa9d76491b7976e7d44ff9219';
```

### 4. Configurer Google Maps

#### Android
Dans `android/app/src/main/AndroidManifest.xml`, ajoutez dans `<application>` :
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="VOTRE_CLE_GOOGLE_MAPS"/>
```

#### iOS
Dans `ios/Runner/AppDelegate.swift` :
```swift
GMSServices.provideAPIKey("VOTRE_CLE_GOOGLE_MAPS")
```

### 5. Lancer l'application

```bash
flutter run
```

---

## 🏗️ Architecture

```
lib/
├── main.dart                        
├── core/
│   ├── constants/
│   │   ├── app_colors.dart          
│   │   ├── app_strings.dart         
│   │   └── app_theme.dart          
│   ├── network/
│   │   ├── api_client.dart         
│   │   └── network_exceptions.dart  
│   └── utils/
│       └── result.dart              
├── data/
│   ├── models/
│   │   ├── weather_model.dart       
│   │   └── weather_model.g.dart     
│   ├── repositories/
│   │   └── weather_repository.dart  
│   └── services/
│       ├── weather_api_service.dart 
│       └── weather_api_service.g.dart
└── presentation/
    ├── providers/
    │   ├── weather_provider.dart    
    │   └── theme_provider.dart      
    ├── screens/
    │   ├── splash_screen.dart
    │   ├── loading_screen.dart
    │   ├── results_screen.dart
    │   └── city_detail_screen.dart
    └── widgets/
        ├── animated_gauge.dart      
        ├── weather_table.dart       
        ├── city_card.dart           
        └── error_widget.dart        
```

---

## 📦 Dépendances principales

| Package | Rôle |
|---------|------|
| `flutter_riverpod` | State management |
| `dio` | Client HTTP |
| `retrofit` | Génération des services API |
| `google_maps_flutter` | Carte interactive |
| `animated_text_kit` | Messages rotatifs animés |
| `google_fonts` | Police Poppins |
| `json_serializable` | Sérialisation JSON |

---

## 🌐 API OpenWeatherMap

Endpoint utilisé :
```
GET https://api.openweathermap.org/data/2.5/weather
    ?q={city}&appid={key}&units=metric&lang=fr
```

Villes configurées : Paris, Dakar, New York, Tokyo, London

---

## 🎨 Design Tokens

### Light Mode
- Background : `#F0F4FF`
- Primary : `#2196F3`
- Cards : `#FFFFFF`

### Dark Mode  
- Background : `#0A0E27`
- Primary : `#64B5F6`
- Cards : `#1E2240`

---

## ⚠️ Notes importantes

- Les fichiers `.g.dart` sont pré-générés (pas besoin de `build_runner`)
- La clé API OpenWeatherMap **doit être remplacée** avant le premier lancement
- Google Maps nécessite une clé API séparée avec l'API Maps SDK activée
- Null safety Dart 3.x obligatoire

---

## 👨‍💻 Développé avec Flutter 3.x + Dart 3.x
