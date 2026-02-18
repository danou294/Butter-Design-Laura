# Butter - Guide de restaurants

Application mobile de découverte de restaurants à Paris. Butter aide les utilisateurs à trouver les meilleures adresses grâce à des recommandations personnalisées, des guides thématiques et un système de recherche avancé.

## Fonctionnalités

- **Accueil** — Recommandations personnalisées et carrousels thématiques
- **Recherche** — Filtres par cuisine, arrondissement, budget, ambiance et occasion
- **Guides** — Sélections éditoriales de restaurants (ex: "Restaurants italiens pour un first date")
- **Favoris** — Sauvegarde de restaurants et de guides dans des collections personnalisées
- **Fiche restaurant** — Photos, infos pratiques, contact WhatsApp pour réserver
- **Compte** — Profil, recommandations, notifications, réglages et Butter+

## Stack technique

- **Framework** : Flutter (Dart)
- **Plateformes** : iOS, Web, macOS
- **Design** : iPhone 12 Pro (390×844pt) comme référence
- **Police** : Inter (Google Fonts) + Inria Sans pour les cartes
- **Icônes** : SVG custom (`design/icones/`)

## Dépendances

| Package | Usage |
|---------|-------|
| `google_fonts` | Typographie Inter & Inria Sans |
| `flutter_svg` | Icônes SVG personnalisées |
| `url_launcher` | Liens externes (App Store, réseaux sociaux, email) |
| `share_plus` | Partage natif de restaurants |

## Lancer le projet

```bash
cd butter_app
flutter pub get
flutter run -d chrome      # Web
flutter run -d ios          # iOS Simulator
```

## Structure du projet

```
butter_app/
├── lib/
│   ├── main.dart                  # Point d'entrée, navigation par onglets
│   ├── screens/                   # Écrans de l'app
│   │   ├── home_screen.dart
│   │   ├── search_screen.dart
│   │   ├── results_screen.dart
│   │   ├── guides_screen.dart
│   │   ├── guide_detail_screen.dart
│   │   ├── favorites_screen.dart
│   │   ├── restaurant_detail_screen.dart
│   │   ├── account_screen.dart
│   │   └── settings_screen.dart
│   ├── widgets/                   # Composants réutilisables
│   ├── models/                    # Modèles de données
│   ├── theme/                     # Thème, couleurs, icônes
│   └── utils/                     # Utilitaires (responsive)
├── design/icones/                 # Icônes SVG
└── assets/                        # Images et logos

Design/
├── DIMENSIONS.md                  # Spécifications dimensionnelles complètes
├── PROMPT_REPRODUCTION.md         # Guide de reproduction pixel-perfect
├── TEMPLATE_PAGE_RESTO.md         # Template fiche restaurant
├── Logos Butter/                  # Logos de l'app
└── Screenshots Figma/             # Maquettes Figma de référence
```

## Design

Les fichiers dans le dossier `Design/` contiennent toutes les spécifications nécessaires pour reproduire l'app à l'identique :
- **DIMENSIONS.md** : Toutes les dimensions, couleurs et espacements
- **PROMPT_REPRODUCTION.md** : Instructions détaillées pour recréer chaque écran
- **Screenshots Figma/** : Maquettes de référence

## Liens

- [App Store](https://apps.apple.com/fr/app/butter-guide-de-restaurants/id6749227938)
- [Instagram](https://www.instagram.com/butterguide)
- [LinkedIn](https://www.linkedin.com/company/butterappli/)
- [TikTok](https://www.tiktok.com/@butterguide)
