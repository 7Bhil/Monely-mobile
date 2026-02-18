# Monely Mobile - Application Flutter

Application mobile multi-plateforme pour la gestion budgétaire intelligente.

## 📱 Description

Monely Mobile est une application Flutter native offrant une expérience complète de gestion financière sur iOS et Android, avec synchronisation en temps réel et intelligence artificielle.

## 🛠️ Stack Technique

- **Flutter 3.10.1+** - Framework multi-plateforme
- **Dart** - Langage de programmation principal
- **Flutter BLoC 9.1.1** - Gestion d'état par pattern
- **Go Router 17.1.0** - Navigation déclarative
- **Dio 5.9.1** - Client HTTP avec intercepteurs
- **FL Chart 1.1.1** - Graphiques interactifs
- **Google Fonts 8.0.1** - Typographie moderne
- **Shared Preferences 2.5.4** - Stockage local
- **Get It 9.2.0** - Injection de dépendances
- **Equatable 2.0.8** - Comparaison d'objets
- **Dartz 0.10.1** - Programmation fonctionnelle

## 🚀 Installation

### Prérequis
- Flutter SDK (version 3.10.1 ou supérieure)
- Android Studio / Xcode
- Émulateur ou appareil physique

### Étapes

```bash
# 1. Cloner et naviguer dans le dossier
cd mobile

# 2. Installer les dépendances
flutter pub get

# 3. Vérifier la configuration
flutter doctor

# 4. Lancer l'application
flutter run
```

## 📁 Structure du Projet

```
mobile/
├── lib/                    # Code source Dart
│   ├── main.dart          # Point d'entrée
│   ├── app.dart           # Configuration de l'app
│   ├── core/              # Configuration globale
│   │   ├── constants/     # Constantes de l'app
│   │   ├── errors/        # Gestion des erreurs
│   │   ├── network/       # Configuration réseau
│   │   └── utils/         # Utilitaires
│   ├── features/          # Fonctionnalités par module
│   │   ├── authentication/# Authentification
│   │   ├── transactions/  # Gestion des transactions
│   │   ├── wallets/       # Gestion des portefeuilles
│   │   ├── analytics/     # Analyses et statistiques
│   │   └── profile/       # Profil utilisateur
│   ├── shared/            # Composants partagés
│   │   ├── widgets/       # Widgets réutilisables
│   │   ├── models/        # Modèles de données
│   │   └── services/      # Services partagés
│   └── l10n/              # Internationalisation
├── assets/                # Assets statiques
│   ├── images/           # Images et icônes
│   └── fonts/            # Polices personnalisées
├── android/              # Configuration Android
├── ios/                  # Configuration iOS
├── web/                  # Configuration Web
├── test/                 # Tests unitaires et widgets
├── pubspec.yaml          # Dépendances et configuration
└── analysis_options.yaml # Règles d'analyse statique
```

## 🎨 Fonctionnalités

### Gestion Financière
- **Portefeuilles multiples** : Comptes courants, épargne, cartes de crédit
- **Transactions intelligentes** : Catégorisation automatique
- **Objectifs d'épargne** : Suivi de progression avec notifications
- **Budgets par catégorie** : Alertes de dépassement

### Analyses et Visualisations
- **Tableaux de bord** : Vue d'ensemble financière
- **Graphiques interactifs** : Tendances et répartitions
- **Export de données** : Rapports PDF et CSV
- **Mode sombre/clair** : Adaptation automatique

### Intelligence Artificielle
- **Conseils personnalisés** : Recommandations basées sur les habitudes
- **Détection d'anomalies** : Alertes de dépenses inhabituelles
- **Prédictions** : Projections basées sur l'historique

### Synchronisation
- **Sync en temps réel** : Avec le backend et l'interface web
- **Mode hors ligne** : Fonctionnalité complète sans connexion
- **Sauvegarde automatique** : Dans le cloud

## 🔧 Scripts et Commandes

```bash
# Développement
flutter run                    # Lancer sur appareil/émulateur
flutter run -d chrome         # Lancer version web
flutter run --debug           # Mode debug
flutter run --profile         # Mode profilage

# Build
flutter build apk             # APK Android
flutter build appbundle       # App Bundle Google Play
flutter build ios             # Build iOS
flutter build web             # Build web

# Tests
flutter test                  # Tests unitaires
flutter test --coverage      # Tests avec couverture

# Outils
flutter clean                 # Nettoyer le projet
flutter pub upgrade           # Mettre à jour les dépendances
flutter doctor                # Vérifier la configuration
```

## 🎯 Architecture

### Pattern BLoC
Utilisation du pattern BLoC pour la séparation des responsabilités :
- **Blocs** : Gestion de la logique métier
- **Events** : Actions utilisateur
- **States** : États de l'interface
- **Repositories** : Accès aux données

### Injection de Dépendances
Configuration avec GetIt :
- Services réseau
- Bases de données locales
- Repositories
- BLoCs

### Navigation
Go Router pour une navigation type-safe :
- Routes nommées
- Navigation imbriquée
- Guard d'authentification
- Deep linking

## 📱 Plates-formes Supportées

### ✅ Disponible
- **Android** (API 21+)
- **iOS** (iOS 12.0+)
- **Web** (Chrome, Safari, Firefox)
- **Windows** (Windows 10+)
- **Linux** (Ubuntu 18.04+)
- **macOS** (macOS 10.14+)

### 🎯 Cibles Principales
- Mobile : Android et iOS
- Desktop : Windows et macOS

## ⚙️ Configuration

### Variables d'Environnement

Créer `lib/core/constants/app_constants.dart` :

```dart
class AppConstants {
  static const String apiBaseUrl = 'https://votre-api.com';
  static const String apiKey = 'votre_cle_api';
  static const bool enableDebugMode = true;
}
```

### Personnalisation

- **Thème**: `lib/core/theme/app_theme.dart`
- **Couleurs**: `lib/core/theme/app_colors.dart`
- **Polices**: `assets/fonts/`
- **Icônes**: `assets/images/`

## 🔗 Intégration API

### Client HTTP
Configuration de Dio avec :
- Interceptors pour les tokens JWT
- Gestion des erreurs centralisée
- Logging en développement
- Timeout configurables

### Endpoints Principaux
```dart
// Authentification
POST /api/auth/login
POST /api/auth/register
POST /api/auth/refresh

// Transactions
GET /api/transactions/
POST /api/transactions/
PUT /api/transactions/{id}/

// Portefeuilles
GET /api/wallets/
POST /api/wallets/
```

## 🧪 Tests

### Structure des Tests
```
test/
├── unit/                   # Tests unitaires
│   ├── blocs/            # Tests des BLoCs
│   ├── repositories/     # Tests des repositories
│   └── services/         # Tests des services
├── widget/                # Tests de widgets
└── integration/           # Tests d'intégration
```

### Commandes de Test
```bash
flutter test                              # Tous les tests
flutter test test/unit/blocs/             # Tests BLoC uniquement
flutter test --coverage                   # Avec couverture
genhtml coverage/lcov.info                 # Rapport HTML
```

## 🚀 Déploiement

### Google Play Store
```bash
# Build signed APK/AAB
flutter build appbundle --release

# Upload sur Google Play Console
# Configurer les métadonnées, captures d'écran
```

### Apple App Store
```bash
# Build iOS
flutter build ios --release

# Configuration dans Xcode
# Certificats, profils, métadonnées
# Upload via Xcode Organizer
```

### Web Deployment
```bash
# Build web
flutter build web

# Déployer le dossier build/web/
# Sur Netlify, Vercel, Firebase Hosting
```

## 📝 Bonnes Pratiques

### Code Style
- Suivre les conventions Dart/Flutter
- Utiliser `dart format` pour le formatage
- Activer `flutter_lints` dans `analysis_options.yaml`

### Performance
- Utiliser `const` constructeurs quand possible
- Éviter les rebuilds inutiles avec `const` widgets
- Optimiser les images et assets
- Utiliser `ListView.builder` pour les listes longues

### Sécurité
- Ne jamais stocker de clés API en dur
- Utiliser `flutter_secure_storage` pour les données sensibles
- Valider les entrées utilisateur
- Utiliser HTTPS pour toutes les communications

## 🤝 Contribution

1. Forker le projet
2. Créer une branche : `git checkout -b feature/nouvelle-fonctionnalite`
3. Commiter : `git commit -m 'Feat: ajout nouvelle fonctionnalité'`
4. Pousser : `git push origin feature/nouvelle-fonctionnalite`
5. Créer une Pull Request avec description détaillée

## 📄 Licence

MIT License - voir le fichier LICENSE pour plus de détails.

## 🔗 Liens Utiles

- [Documentation Flutter](https://flutter.dev/docs)
- [Flutter BLoC Library](https://bloclibrary.dev/)
- [Go Router](https://pub.dev/packages/go_router)
- [Dio HTTP Client](https://pub.dev/packages/dio)
- [FL Chart](https://pub.dev/packages/fl_chart)

## 📞 Support

Pour toute question ou problème, créer une issue dans le repository GitHub avec :
- Description détaillée du problème
- Étapes pour reproduire
- Capture d'écran si applicable
- Informations sur l'appareil/émulateur
