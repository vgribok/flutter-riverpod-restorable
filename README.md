A Riverpod provider for Flutter State Restoration.

## Features
Riverpod doesn't provide a simple way to restore ephemeral state when an app gets 
killed by the OS. This package provides a way to do that.

## Usage
How to register global providers for restoration:

```dart
final counterProvider = RestorableProvider(
    // our default value
    (ref) => RestorableInt(0),
    // each provider needs a unique restorationId
    restorationId: 'counterProvider',
);

MaterialApp(
    // Required to restore state
    restorationScopeId: 'root',
    // Required to register global providers for restoration
    builder: (context, child) => RestorableProviderRegister(
        restorationId: 'app',
        providers: [
            // list your providers here
            counterProvider,
        ],
        child: child ?? const SizedBox.shrink(),
    ),
);
```
How to register overridden providers for restoration:

```dart
RestorableProviderScope(
    restorationId: 'counter_page_scope',
    restorableOverrides: [
        // use overrideWithRestorable instead of overrideWithValue
        counterProvider.overrideWithRestorable(RestorableInt(0)),
    ],
    child: const CounterPage(),
)
```

## Additional information
For information on how to restore navigation, see the example or https://api.flutter.dev/flutter/widgets/Navigator-class.html#state-restoration