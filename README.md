# 🎬 Filmania

Modern Flutter app for movie fans. Discover films, manage watchlist, track cinematic journey. Focus on clean code, robust architecture. Seamless, performant UX.

## ✨ Features

- **Discover**: Browse trending, popular, upcoming movies.
- **Watchlist**: Save movies to watch later.
- **Profile**: Manage personal preferences.
- **Aura Cinema Design System**: Custom design system. Premium, consistent visual experience.

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

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (v3.11.4+)
- Dart SDK
- [Supabase Project](https://supabase.com/)

### Installation

1. **Clone repository**
   ```bash
   git clone https://github.com/yourusername/filmania.git
   cd filmania
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate files**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run app**
   ```bash
   flutter run
   ```

## 🏗️ Project Structure

Clean Architecture. Feature-based modules:

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

Styles + components for polished, immersive UI. Modern, cinematic themes.

## 📄 License

MIT License.
