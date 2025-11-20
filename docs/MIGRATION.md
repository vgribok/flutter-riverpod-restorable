# Riverpod Restorable: v.2 vs v.3 Syntax Comparison

## ❌ NOT Source-Code Compatible

The v.2 and v.3 APIs are **NOT compatible**. Migration requires code changes.

---

## 1. Provider Declaration

### v.2 (Riverpod 2.x)
```dart
final counterProvider = RestorableProvider<RestorableInt>(
  (ref) => RestorableInt(0),
  restorationId: 'counterProvider',
);
```

### v.3 (Riverpod 3.x)
```dart
final counterProvider = restorableProvider<RestorableInt>(
  create: (ref) => RestorableInt(0),
  restorationId: 'counter',
);
```

**Changes:**
- `RestorableProvider` class → `restorableProvider` function
- Positional callback → Named `create:` parameter
- Returns `NotifierProvider` instead of custom provider class

---

## 2. Global Provider Registration

### v.2 (Riverpod 2.x)
```dart
MaterialApp(
  restorationScopeId: 'root',
  builder: (context, child) => RestorableProviderRegister(
    restorationId: 'app',
    providers: [counterProvider],
    child: child!,
  ),
  home: const HomePage(),
)
```

### v.3 (Riverpod 3.x)
```dart
MaterialApp(
  restorationScopeId: 'app',
  home: RestorableProviderScope(
    restorationId: 'main',
    providers: [counterProvider],
    child: const HomePage(),
  ),
)
```

**Changes:**
- `RestorableProviderRegister` → `RestorableProviderScope`
- No longer requires `builder:` wrapper
- Simplified placement in widget tree

---

## 3. Scoped Provider Overrides

### v.2 (Riverpod 2.x)
```dart
RestorableProviderScope(
  restorationId: 'counter_page_scope',
  restorableOverrides: [
    counterProvider.overrideWithRestorable(RestorableInt(10)),
  ],
  child: const CounterPage(),
)
```

### v.3 (Riverpod 3.x)
```dart
// NOT SUPPORTED in v.3
// Use standard Riverpod v.3 override mechanisms instead
ProviderScope(
  overrides: [
    counterProvider.overrideWith((ref) => RestorableInt(10)),
  ],
  child: RestorableProviderScope(
    restorationId: 'counter_page',
    providers: [counterProvider],
    child: const CounterPage(),
  ),
)
```

**Changes:**
- `restorableOverrides` parameter removed
- Use standard `ProviderScope.overrides` with nested `RestorableProviderScope`
- `overrideWithRestorable()` method no longer exists

---

## 4. Reading Provider Values

### v.2 (Riverpod 2.x)
```dart
final counter = ref.watch(counterProvider);
counter.value++;  // Works
```

### v.3 (Riverpod 3.x)
```dart
final counter = ref.watch(counterProvider);
counter.value++;  // Works - triggers rebuild via ChangeNotifier
```

**Changes:**
- ✅ Same syntax
- ✅ v.3 properly triggers rebuilds via NotifierProvider

---

## 5. Widget Usage

### v.2 (Riverpod 2.x)
```dart
class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);
    return Text('${counter.value}');
  }
}
```

### v.3 (Riverpod 3.x)
```dart
class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);
    return Text('${counter.value}');
  }
}
```

**Changes:**
- ✅ Identical syntax

---

## Summary of Breaking Changes

| Feature | v.2 | v.3 | Compatible? |
|---------|-----|-----|-------------|
| Provider declaration | `RestorableProvider(...)` | `restorableProvider(create: ...)` | ❌ No |
| Registration widget | `RestorableProviderRegister` | `RestorableProviderScope` | ❌ No |
| Provider type | Custom class | `NotifierProvider` | ❌ No |
| Scoped overrides | `restorableOverrides` | Standard `ProviderScope.overrides` | ❌ No |
| Reading values | `ref.watch(provider).value` | `ref.watch(provider).value` | ✅ Yes |
| Widget usage | Same | Same | ✅ Yes |

---

## Migration Checklist

- [ ] Replace `RestorableProvider(...)` with `restorableProvider<T>(create: ...)`
- [ ] Replace `RestorableProviderRegister` with `RestorableProviderScope`
- [ ] Add `providers: [...]` parameter with list of providers
- [ ] Move registration from `MaterialApp.builder` to direct child
- [ ] Replace `restorableOverrides` with standard `ProviderScope.overrides`
- [ ] Remove `.overrideWithRestorable()` calls
- [ ] Test that rebuilds work correctly when values change
