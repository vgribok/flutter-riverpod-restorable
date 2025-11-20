## 3.0.0

**COMPLETE REWRITE for Riverpod v.3**

This is a greenfield redesign with breaking changes.

### Breaking Changes

- Complete API redesign for Riverpod v.3 compatibility
- Minimum Dart SDK: `>=3.0.0`
- Minimum Flutter SDK: `>=3.10.0`
- Riverpod: `^3.0.3`

### New API

- `restorableProvider()` - Factory function to create restorable providers
- `RestorableProviderScope` - Widget to register providers for restoration
- `getRestorationId()` - Helper to retrieve restoration IDs

### Migration

**Old (v.2):**
```dart
final provider = RestorableProvider(
  (ref) => RestorableInt(0),
  restorationId: 'counter',
);

RestorableProviderRegister(
  restorationId: 'app',
  providers: [provider],
  child: child,
)
```

**New (v.3):**
```dart
final provider = restorableProvider<RestorableInt>(
  create: (ref) => RestorableInt(0),
  restorationId: 'counter',
);

RestorableProviderScope(
  restorationId: 'app',
  providers: [provider],
  child: child,
)
```

### Features

- ✅ Ephemeral state preservation with Riverpod v.3
- ✅ Uses modern Riverpod v.3 APIs (NotifierProvider)
- ✅ No deprecated dependencies
- ✅ Minimal boilerplate (~100 lines of code)
- ✅ Works with all `RestorableProperty` types
- ✅ Simple, clean API

## 2.0.0

* Updated dependencies to Riverpod v.2
* Decompiled from flutter_riverpod_restorable package
