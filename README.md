Exam Flutter — Application Météo Mondiale
Projet réalisé dans le cadre de l'examen de Développement Mobile 
Membres du groupe : 
- Amadou Diogo Ba, 
- Mamadou François Toure, 
- Awa Ndao

Présentation
C'est une application Flutter qu'on a développée pour l'examen. L'idée c'est simple : l'utilisateur lance l'appli, il voit un écran d'accueil sympa, il clique sur le bouton et l'appli commence à charger la météo en temps réel pour 5 villes dans le monde (Paris, Dakar, New York, Tokyo et London). Pendant le chargement y'a une jauge animée qui se remplit progressivement avec des messages qui tournent en boucle pour indiquer l'avancement. Une fois que tout est chargé, les résultats s'affichent sous forme de liste et on peut cliquer sur n'importe quelle ville pour voir ses informations détaillées ainsi que sa position exacte sur une carte interactive.
On a essayé de faire quelque chose de propre côté design avec un thème sombre et clair qu'on peut switcher à tout moment depuis n'importe quel écran. Pour les données météo on utilise l'API OpenWeatherMap et pour la carte on a utilisé flutter_map avec OpenStreetMap qui est 100% gratuit et ne nécessite pas de clé API contrairement à Google Maps.
