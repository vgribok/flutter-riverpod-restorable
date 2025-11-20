# Riverpod Restorable Example

Demonstrates ephemeral state restoration with Riverpod v.3.

## Running the Example

```bash
cd example
flutter run
```

## Testing State Restoration

### iOS Simulator
1. Run the app
2. Increment the counter
3. Press Home button (Cmd+Shift+H)
4. Stop the app from Xcode or `flutter run`
5. Relaunch the app
6. Counter value should be preserved

### Android Emulator
1. Enable Developer Options
2. Enable "Don't keep activities"
3. Run the app and increment counter
4. Press Home button
5. Return to app
6. Counter value should be preserved

## Code Overview

```dart
// Define restorable provider
final counterProvider = restorableProvider<RestorableInt>(
  create: (ref) => RestorableInt(0),
  restorationId: 'counter',
);

// Wrap app with RestorableProviderScope
RestorableProviderScope(
  restorationId: 'main',
  child: const HomePage(), // Auto-discovers all providers
)

// Use in widgets
final counter = ref.watch(counterProvider);
counter.value++; // Triggers rebuild and saves state
```
