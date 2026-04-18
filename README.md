# 🧘 Immerse — Immersive Session & Reflection

A calm, meditation-style Flutter app with immersive audio sessions, breathing animations, and post-session reflections.

---

## ✨ Features

| Feature | Description |
|---|---|
| **Home** | Browse 6 curated ambiences with search & tag filters |
| **Details** | Full session info with sensory experience tags |
| **Player** | Audio playback with breathing animation, timer & progress |
| **Mini Player** | Persistent bottom bar when navigating away from player |
| **Reflection** | Mood selection & free-text journaling after each session |
| **History** | Browse saved reflections with full detail view |

## 📂 Project Structure

```
lib/
├── main.dart              # Entry point (Hive init)
├── app.dart               # MaterialApp + providers
├── data/
│   ├── models/            # Ambience, JournalEntry
│   └── datasources/       # JSON loader, Hive CRUD
├── features/
│   ├── home/              # Home screen + widgets
│   ├── details/           # Ambience detail screen
│   ├── player/            # Player + breathing animation + mini player
│   ├── reflection/        # Post-session reflection
│   └── history/           # Journal history + detail sheet
└── shared/
    ├── theme/             # Colors, typography, theme
    ├── providers/         # AmbienceProvider, SessionProvider, JournalProvider
    └── widgets/           # EmptyState, MoodChip
```

## 🛠 Tech Stack

- **Flutter 3.x** with Material 3
- **Provider** — State management via ChangeNotifier
- **Hive** — Local persistence for journal entries
- **just_audio** — Audio playback with looping
- **Google Fonts** — Outfit typeface for premium typography
- **uuid** — Unique IDs for journal entries

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ≥ 3.0.0
- Android Studio / VS Code

### Setup

```bash
# Clone and enter project
cd "Immersive Session and Reflection Mini App"

# Install dependencies
flutter pub get

# Run on connected device/emulator
flutter run
```

### Adding Audio Files

Place `.mp3` audio files in `assets/audio/` matching the names in `ambiences.json`:

```
assets/audio/
├── forest_rain.mp3
├── ocean_waves.mp3
├── mountain_wind.mp3
├── tibetan_bowls.mp3
├── night_garden.mp3
└── cosmic_drift.mp3
```

> **Note:** The app works without audio files — the session timer and all UI functions independently. Audio is a bonus layer.

You can download free ambient sounds from:
- [freesound.org](https://freesound.org)
- [mixkit.co](https://mixkit.co/free-sound-effects/)
- [pixabay.com/sound-effects](https://pixabay.com/sound-effects/)

## 📦 Build APK

### Debug APK
```bash
flutter build apk --debug
```

### Release APK
```bash
flutter build apk --release
```

The APK will be generated at:
```
build/app/outputs/flutter-apk/app-release.apk
```

## 📱 App Flow

```
Home → Details → Player → Reflection → Home
                    ↕
              Mini Player (background)
                    ↕
                 History
```

## 🎨 Design Highlights

- **Deep dark theme** with calming purple/blue palette
- **Glassmorphic cards** with color-coded gradients per ambience
- **Breathing animation** — multi-ring pulsing circles on the player
- **Mood-colored chips** with emoji indicators
- **Smooth transitions** and micro-interactions throughout

---

Made with 💜 using Flutter
