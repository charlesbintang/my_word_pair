# Copilot / AI Agent Instructions

Purpose: quick, actionable guidance for AI coding agents working on this Flutter app.

Big picture
- Single-page Flutter app (Material 3) using `provider` + `ChangeNotifier` for state.
- UI split into `Generator` and `Favorites` screens; navigation handled in `lib/screens/home_page.dart`.
- App state lives in `MyAppState` (`lib/viewmodels/app_viewmodel.dart`) — single source of truth for `current`, `history`, and `favorites`.
- Persistence/integration: `WordPairService` (`lib/services/wordpair_service.dart`) sends/receives JSON to a backend at port 3000. Entities are defined in `lib/data/entities/wordpair.dart`.

Key files to read first
- `lib/main.dart` — app bootstrap and provider wiring.
- `lib/viewmodels/app_viewmodel.dart` — core state, business logic, and where API calls are made.
- `lib/services/wordpair_service.dart` — HTTP client, error-handling strategy, and platform-specific base URL logic.
- `lib/screens/*` and `lib/widgets/*` — UI components (GeneratorPage, FavoritesPage, BigCard, HistoryListView).

Important patterns & conventions (observable from code)
- State & provider: `ChangeNotifierProvider` created in `main.dart`; `MyAppState` exposes methods like `getNext()`, `toggleFavorite()`, `loadFavorites()`; use `context.watch<MyAppState>()` or `context.read<MyAppState>()` in widgets.
- Network resiliency: `WordPairService` swallows network exceptions and returns empty lists on failure — do not assume persistent failures should crash the app.
- Env/config: project uses `flutter_dotenv`. The backend address is read from `dotenv.env['IP_ADDRESS']`. For Android devices you may need to set this to the host IP or emulator loopback (10.0.2.2) depending on target.
- Naming quirk: boolean `isNotSavedLocally` is inverted (when true, the app sends pairs to the backend). Handle carefully when changing save logic.
- UI patterns: `HistoryListView` uses an `AnimatedList` with a `GlobalKey` stored in `MyAppState` to allow insertion animations from the viewmodel.

Backend & environment notes
- Backend expected at `http://<IP>:3000/wordpairs`. For development:
  - Web/iOS/desktop: `http://localhost:3000/wordpairs` works.
  - Android emulator/physical device: set `.env` `IP_ADDRESS` to `10.0.2.2` (emulator) or host LAN IP (device).
- Create a `.env` in repo root with `IP_ADDRESS=<ip>` before running on mobile devices.

Developer workflows (commands)
- Run app (choose device):
```
flutter run
```
- Run tests:
```
flutter test
```
- Static analysis/formatting:
```
flutter analyze
flutter format .
```
- Build releases:
```
flutter build apk
flutter build ios
```

Common pitfalls & quick fixes
- If favorites fail to load, check `.env` and backend availability; `WordPairService` logs errors via `debugPrint`.
- When changing how favorites/history are saved, update both `MyAppState` and `WordPairService` (client-side flag `isNotSavedLocally` controls whether `createWordPair` is called).
- Do not change the `historyListKey` mechanism without updating both `HistoryListView` and `MyAppState`.

Where to add tests or instrumentation
- Unit-test `WordPairService` by mocking HTTP responses (it returns empty lists on error — assert that behavior).
- `MyAppState` methods (`getNext`, `toggleFavorite`, `loadFavorites`) are good unit-test targets.

If you change behavior that touches persistence/network: update `lib/data/entities/wordpair.dart` shape expectations and ensure JSON keys (`firstWord`, `secondWord`, `category`) match backend.

Questions for maintainers (ask if unclear)
- Is `isNotSavedLocally` intentionally inverted? Changing it requires careful migration of comments and behavior.
- Is there a documented backend contract (schema, query params) beyond what's in `WordPairService`?

If unsure where to change something: start at `lib/viewmodels/app_viewmodel.dart`, follow callers in `lib/screens/` and `lib/widgets/`.

— end —
