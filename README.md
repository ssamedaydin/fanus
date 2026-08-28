# Fanus

Fanus is a personal focus and digital balance app. You define your work areas on a map; when you enter one, a focus session starts automatically — and distracting apps can be shielded until you leave.

The project is a [melos](https://melos.invertase.dev)-managed Flutter monorepo. Platform-specific capabilities (background location, screen-time restrictions) are implemented natively in Kotlin and Swift and exposed to Flutter through dedicated plugin packages.

## Architecture

```
fanus/
├── apps/
│   └── fanus_app/        # Flutter app (hooks_riverpod, go_router, slang)
└── packages/
    ├── fanus_core/       # domain models (freezed), focus session engine, services (dio)
    └── fanus_design/     # design system: theme, spacing, shared widgets
```

Planned plugin packages: `fanus_location` (geofencing + battery-friendly background location) and `fanus_screen_time` (app usage tracking and restriction).

The heart of the app is `SessionEngine` in `fanus_core` — a pure, unit-tested state machine that turns geofence enter/exit events into focus sessions, with an exit-grace period so GPS jitter never splits a session.

## Roadmap

- [x] Monorepo skeleton: core models + session engine (tested), design system, app shell
- [x] Map screen: define circular work areas on Google Maps (long-press to add, radius picker, persisted locally)
- [x] `fanus_location` plugin — Android: GeofencingClient + foreground service (Kotlin); iOS: region monitoring + background location (Swift, compilation verified on macOS separately)
- [x] `fanus_screen_time` plugin — Android: UsageStatsManager, Accessibility Service, DevicePolicyManager (Kotlin); iOS: FamilyControls, DeviceActivity, ManagedSettings + Shield Extension sample (Swift, compilation verified on macOS separately)
- [ ] Shared focus rooms: real-time presence over WebSocket, reconnect/backoff handling
- [ ] OneSignal push notifications, Sentry error tracking
- [ ] TR/EN localization with slang

> **Note on iOS screen-time features:** FamilyControls uses `.individual` authorization and requires the Family Controls entitlement; a development entitlement is sufficient to run the demo on a device.

## Development

Requires Flutter 3.44+ / Dart 3.12+ (pub workspaces).

```
dart pub get                  # resolves the whole workspace from the root
dart run melos run analyze    # static analysis
dart run melos run test       # tests in every package that has them
```

The map screen needs a Google Maps key. It is never committed; put it in
`apps/fanus_app/android/local.properties` as `maps.apiKey=YOUR_KEY`
(or export `MAPS_API_KEY`). On iOS the key is provided in `AppDelegate`.
