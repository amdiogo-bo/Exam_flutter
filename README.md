Exam Flutter — Application Météo Mondiale

Examen Développement Mobile – L3GL ISI 2026

👨‍💻 Membres du groupe :

Amadou Diogo Ba

Mamadou François Touré

Awa Ndao

🎯 Présentation du Projet

Dans le cadre de l’examen de Développement Mobile, nous avons réalisé une application Flutter complète permettant de consulter des données météo en temps réel pour plusieurs villes du monde.

L’objectif était de créer une application moderne, fluide et bien structurée, intégrant :

Des appels API en temps réel

Une jauge de progression animée

Une carte interactive Google Maps

Un mode sombre / clair

Une gestion propre des erreurs

Une architecture propre et organisée

📱 Description Fonctionnelle
1️⃣ Écran d’accueil (Splash Screen)

Lorsque l’utilisateur lance l’application :

Un message d’accueil s’affiche.

Une animation d’introduction rend l’expérience plus agréable.

Un bouton permet de démarrer l’expérience.

L’objectif est d’offrir une première impression moderne et professionnelle.

2️⃣ Écran Principal (Chargement + Résultats)

Après avoir cliqué sur le bouton :

🔄 Jauge animée

Une jauge de progression se remplit automatiquement avec animation fluide :

Changement de couleur progressif :

Cela donne un effet dynamique pendant le chargement des données.

🌐 Appels API en parallèle

L’application effectue des appels API vers OpenWeatherMap pour 5 villes :

Paris

Dakar

New York

Tokyo

London

Les requêtes sont exécutées en parallèle avec Retrofit.

💬 Messages dynamiques

Pendant le chargement, des messages tournent en boucle :

"Nous téléchargeons les données…"

"C’est presque fini…"

"Plus que quelques secondes avant d’avoir le résultat…"

Cela améliore l’expérience utilisateur pendant l’attente.

💥 Affichage des résultats

Une fois la jauge remplie :

👉 Un tableau interactif s’affiche avec :

Température

Description météo

Humidité

Vitesse du vent

Les données sont affichées proprement avec un design moderne.

3️⃣ Page Détail d’une Ville

Quand l’utilisateur clique sur une ville :

Une nouvelle page s’ouvre avec :

Informations détaillées

Température ressentie

Pression atmosphérique

Coordonnées géographiques

📍 Carte Google Maps avec marqueur personnalisé

L’utilisateur peut donc visualiser la position exacte de la ville.

4️⃣ Gestion des erreurs

Si l’API échoue :

Un message d’erreur clair s’affiche

Un bouton "Réessayer" permet de relancer les appels API

Cela évite que l’application ne plante et améliore la robustesse.

5️⃣ Mode Sombre & Mode Clair

L’application supporte :

🌞 Mode clair

🌙 Mode sombre

La bascule est instantanée et le thème change entièrement :

Light Mode

Background : #F0F4FF

Primary : #2196F3

Cards : #FFFFFF

Dark Mode

Background : #0A0E27

Primary : #64B5F6

Cards : #1E2240

6️⃣ Rejouabilité

Une fois la jauge remplie :

Elle se transforme en bouton "Recommencer"

L’utilisateur peut relancer l’expérience

Le bouton retour permet de revenir à l’écran d’accueil

🏗️ Architecture Technique

Nous avons utilisé une architecture MVVM + Clean Architecture pour garantir :

Séparation des responsabilités

Code maintenable

Bonne organisation du projet

Structure principale :

lib/
core/
data/
presentation/
🧰 Technologies Utilisées

Flutter 3.x

Dart 3.x

Riverpod (gestion d’état)

Dio (client HTTP)

Retrofit (génération API)

Google Maps Flutter

Json Serializable

Animated Text Kit

🌐 API Utilisée

API météo : OpenWeatherMap

Endpoint :

GET https://api.openweathermap.org/data/2.5/weather
?q={city}&appid={key}&units=metric&lang=fr

Les appels sont effectués en parallèle pour optimiser la performance.

🚀 Installation du Projet
git clone <Exam_flutter>
cd Exam_flutter
flutter pub get
flutter run
