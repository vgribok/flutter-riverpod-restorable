# Riverpod Restorable v.3

Ephemeral state restoration for Riverpod v.3.

## Features

Riverpod doesn't provide a built-in way to restore ephemeral state when an app gets killed by the OS. This package provides a minimal solution that integrates Flutter's restoration system with Riverpod v.3.

## Installation

```yaml
dependencies:
  riverpod_restorable: ^3.0.0
  flutter_riverpod: ^3.0.3
```

## Usage

### 1. Create Restorable Providers

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_restorable/riverpod_restorable.dart';

final counterProvider = restorableProvider<RestorableInt>(
  create: (ref) => RestorableInt(0),
  restorationId: 'counter',
);
```

### 2. Enable State Restoration

Wrap your app with `RestorableProviderScope`:

```dart
void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        restorationScopeId: 'app',
        home: RestorableProviderScope(
          restorationId: 'main',
          providers: [counterProvider],
          child: const HomePage(),
        ),
      ),
    ),
  );
}
```

### 3. Use in Widgets

```dart
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);
    
    return Scaffold(
      body: Center(
        child: Text('Count: ${counter.value}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => counter.value++,
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

## Supported Types

All Flutter `RestorableProperty` types are supported:
- `RestorableInt`
- `RestorableDouble`
- `RestorableString`
- `RestorableBool`
- `RestorableDateTime`
- `RestorableIntN` (nullable int)
- `RestorableDoubleN` (nullable double)
- `RestorableStringN` (nullable string)
- `RestorableBoolN` (nullable bool)
- `RestorableDateTimeN` (nullable DateTime)
- Custom `RestorableProperty` subclasses

## How It Works

1. `restorableProvider` creates a `NotifierProvider` that wraps `RestorableProperty`
2. `RestorableProviderScope` registers providers with Flutter's restoration system
3. When the app is killed and restored, Flutter automatically restores the values
4. Riverpod provides the restored values to your widgets

## Testing

For unit tests, test your business logic separately from restoration:

```dart
// Instead of testing RestorableProperty directly:
test('counter logic', () {
  int counter = 0;
  counter++;
  expect(counter, 1);
});

// Or use widget tests with RestorableProviderScope:
testWidgets('counter increments', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        restorationScopeId: 'test',
        home: RestorableProviderScope(
          restorationId: 'test',
          providers: [counterProvider],
          child: MyWidget(),
        ),
      ),
    ),
  );
  // Test widget behavior
});
```

## Migration from v.2

This is a complete rewrite for Riverpod v.3. The API is simpler:

**v.2:**
```dart
final provider = RestorableProvider(
  (ref) => RestorableInt(0),
  restorationId: 'counter',
);
```

**v.3:**
```dart
final provider = restorableProvider<RestorableInt>(
  create: (ref) => RestorableInt(0),
  restorationId: 'counter',
);
```

## Limitations

- **RestorableProperty registration required**: Values can only be accessed inside `RestorableProviderScope`
  - This is a Flutter framework requirement, not a package limitation
- **Manual provider listing**: Providers must be explicitly listed in `RestorableProviderScope`
  - Ensures you have full control over what state gets restored
  - Prevents accidental restoration of sensitive or transient state

## Documentation

- [CHANGELOG](docs/CHANGELOG.md) - Version history and release notes
- [MIGRATION](docs/MIGRATION.md) - Migrating from v.2 to v.3

## Additional Information

For more on Flutter's restoration system:
- [State Restoration](https://api.flutter.dev/flutter/widgets/RestorationMixin-class.html)
- [Navigator Restoration](https://api.flutter.dev/flutter/widgets/Navigator-class.html#state-restoration)
