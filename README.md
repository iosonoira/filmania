# 🎬 Filmania

Filmania is a modern Flutter application designed for movie enthusiasts. Discover new films, manage your watchlist, and keep track of your cinematic journey. Built with a focus on clean code and robust architecture, it leverages modern Flutter ecosystem tools to provide a seamless and performant user experience.

## ✨ Features

- **Discover**: Browse trending, popular, and upcoming movies.
- **Watchlist**: Save movies you want to watch later.
- **Profile**: Manage your personal preferences.
- **Aura Cinema Design System**: A custom, cohesive design system ensuring a premium, consistent visual experience across the app.

## 🛠️ Technology Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **Architecture**: Clean Architecture (Presentation, Domain, Data layers)
- **State Management**: [Riverpod](https://riverpod.dev/) (`flutter_riverpod`, `riverpod_annotation`)
- **Routing**: [GoRouter](https://pub.dev/packages/go_router)
- **Backend / Auth**: [Supabase](https://supabase.com/)
- **Networking**: [Dio](https://pub.dev/packages/dio)
- **Code Generation**: Freezed, json_serializable, build_runner

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (v3.11.4 or higher)
- Dart SDK
- [Supabase Project](https://supabase.com/) (for backend services)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/filmania.git
   cd filmania
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate files** (Riverpod, Freezed, JSON Serializable)
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 🏗️ Project Structure

The project follows **Clean Architecture** principles, separating code into feature-based modules:

```text
lib/
 ├── core/              # Core functionality (routing, design system, network config)
 ├── features/          # App features (Auth, Discover, Profile, Watchlist)
 │    ├── auth/         # Authentication feature
 │    │    ├── data/    # Data layer (repositories, data sources, models)
 │    │    ├── domain/  # Domain layer (entities, repository interfaces)
 │    │    └── ui/      # Presentation layer (pages, widgets, providers)
 │    └── ...
 └── main.dart          # Entry point
```

## 🎨 Aura Cinema Design System

Filmania utilizes the **Aura Cinema Design System**, an internal set of styling rules and components carefully crafted to deliver a polished and immersive UI, focusing on modern, cinematic themes.

## 📄 License

This project is licensed under the MIT License.
