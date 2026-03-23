# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Deploy

```bash
# Build for Apple TV (real device)
xcodebuild -scheme nexty -destination 'id=fdeb003c5524d1039bab0f27e4fddb3e5973f852' build

# Install on Apple TV "Living Room"
xcrun devicectl device install app --device fdeb003c5524d1039bab0f27e4fddb3e5973f852 \
  ~/Library/Developer/Xcode/DerivedData/nexty-brerhknctdtjtscvujjzffayynal/Build/Products/Debug-appletvos/nexty.app

# Launch on Apple TV
xcrun devicectl device process launch --device fdeb003c5524d1039bab0f27e4fddb3e5973f852 com.talthent.nexty

# Find devices
xcrun xctrace list devices 2>&1 | grep -i "apple tv\|Living"
```

No external dependencies — only system frameworks (MapKit, CoreImage, Network, AVKit, TVServices).

## Architecture

**tvOS kids' daily schedule app** with multi-kid profiles, weather, web dashboard, and bilingual support (English/Hebrew).

### State Management

`AppState` is the single `@Observable` source of truth. Views never mutate state directly — they receive derived state structs and fire callback closures:

```
AppState (@Observable, persists to UserDefaults + app group)
  → HomeState / HeaderViewState / ActivityCardState / SettingsViewState (derived, read-only)
    → Views (purely presentational, communicate via closures)
```

`ContentView` wires `AppState` methods to `HomeView` callbacks. Adding new actions follows this pattern: add method to `AppState`, add closure to `HomeView`, wire in `ContentView`.

### Key Models

- **Kid** — profile with name, avatar (10 options, some with video), wallpaper, and activities list
- **Activity** — schedule item with titleKey (localization), imageName (Lucide icon), hour/minute, optional customTitle
- **Wallpaper** — enum of image-based or gradient-based backgrounds, per-kid
- **Language** — English/Hebrew with RTL support and per-language localization bundles

### Services

- **DashboardServer** — local HTTP server on port 8080 for remote schedule editing from phone. Serves HTML from `DashboardHTML.swift`. Supports weekly templates, per-day overrides, and tomorrow pre-loading via UserDefaults
- **LocationService** — geocoding with locale-aware city names
- **WeatherService** — Open-Meteo API for temperature and weather icons
- **NetworkInfo** — local IP detection for dashboard QR code

### Targets

- **nexty** — main tvOS app
- **topShelf** — Top Shelf extension showing current/next activity per kid. Shares models via file membership and reads from app group `group.com.talthent.nexty`

## Conventions

- **tvOS UI**: Always use `.buttonStyle(.card)` for buttons — native tvOS card style
- **Icons**: Lucide icons as image assets, referenced as `Image("lucide-{name}")`
- **Localization**: `"key".localized(language)` using `Language.bundle`. Add new strings to `Localizable.xcstrings` with both `en` and `he` translations
- **Layout direction**: Injected via `Environment(\.appLanguage)` and `Environment(\.layoutDirection)` for RTL
- **Persistence**: UserDefaults for settings, shared app group defaults for cross-target data (Top Shelf)
- **Concurrency**: `@MainActor` for UI state, `Sendable` + `nonisolated(unsafe)` for services with dispatch queues
