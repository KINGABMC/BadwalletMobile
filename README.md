# CampusNet Mobile - Portefeuille Numérique (BadWallet)

Application mobile de gestion de portefeuille électronique développée avec **Flutter** et s'appuyant sur l'architecture d'état **Provider**. Le projet implémente les flux financiers transactionnels (envoi de fonds, paiement groupé de factures) et interagit avec une API REST backend via le protocole HTTP.

## 🛠️ Stack Technique & Architecture

* **Framework :** Flutter 3.x & Dart 3.x (Null-Safety)
* **State Management :** Provider (Architecture réactive unilatérale)
* **Networking :** Package `http` pour la couche client REST
* **Git Workflow :** Respect strict de la méthodologie **Git Flow** (`main`, `develop`, `features/*`)

Installation et Configuration

Prérequis

    Flutter SDK installé et configuré.

    Le serveur backend démarré et exposé sur le port 8080.

Configuration de l'environnement API

Modifier le fichier lib/core/constant.dart pour mapper l'adresse de votre instance backend :

    Pour l'émulateur Android par défaut : http://10.0.2.2:8080/api

    Pour un appareil physique / iOS : http://<VOTRE_IP_LOCALE>:8080/api

Exécution
Bash

flutter pub get
flutter run

### Arborescence du Projet (`lib/`)

```text
lib/
│   main.dart                   # Point d'entrée de l'application & Injection de dépendances
│
├───core/                       # Configuration transverse & Design System
│       theme.dart              # Palette de couleurs unifiée (Teintes Teal/Cyan)
│       constant.dart           # Centralisation des endpoints d'API (Localhost/Émulateur)
│
├───models/                     # Modèles d'entités fortement typés
│       wallet_model.dart       # Mapping structurel du portefeuille client
│       transaction_model.dart  # Abstraction et parsing des types de transactions (DEPOSIT, TRANSFER...)
│
├───services/                   # Couche d'infrastructure / Services asynchrones
│       api_service.dart        # Client API global, gestion des verbes HTTP (GET, POST) & rafraîchissement d'état
│       auth_service.dart       # Session de persistance locale de l'identifiant utilisateur (Numéro de téléphone)
│
├───screens/                    # Couche Présentation (Vues)
│   ├───auth/
│   │       login_screen.dart   # Authentification par injection du numéro client
│   ├───dashboard/
│   │       home_screen.dart    # Tableau de bord principal, affichage conditionnel du solde
│   ├───transfers/
│   │       transfer_screen.dart# Formulaire transactionnel P2P avec validation de formulaire stricte
│   ├───bills/
│   │       bills_screen.dart   # Module de paiement de factures groupé via sélecteurs atomiques (Checkboxes)
│   └───history/
│           history_screen.dart # Flux d'activité avec discrimination visuelle (Crédit/Débit)
│
└───widgets/                    # Composants d'interface utilisateur découplés et réutilisables
        balance_card.dart       # Carte premium du solde utilisateur (Effet gradient & Masquage dynamique)
        transaction_item.dart   # Ligne de log transactionnelle hautement configurable

