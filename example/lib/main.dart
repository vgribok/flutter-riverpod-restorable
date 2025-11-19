import 'package:flutter/services.dart' show StandardMessageCodec;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_restorable/riverpod_restorable.dart';


/// To test, enable Android Developer Options (https://www.google.com/search?q=android+enable+developer+options&oq=android+enable+&ie=UTF-8)
/// and then enable "Do not keep activities" (https://stackoverflow.com/a/19622671/516508).
/// After that hitting Home button evicts the app.
/// Returning to the app should preserve previous color.
void main() => runApp(const ProviderScope(child: MyApp()));

final materialColors = [
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
  Colors.brown,
  Colors.grey,
  Colors.blueGrey,
];

/// We can only restore values that can be serializable by [StandardMessageCodec].
/// For anything that can't be serialized by [StandardMessageCodec] we must serialize it ourselves.
/// A simple way to do this is to just convert it from/to JSON.
/// See [RestorableProperty] for more info.
class RestorableMaterialColor extends RestorableValue<MaterialColor> {
  RestorableMaterialColor(this._defaultValue);

  final MaterialColor _defaultValue;

  @override
  MaterialColor createDefaultValue() => _defaultValue;

  @override
  void didUpdateValue(MaterialColor? oldValue) => notifyListeners();

  @override
  MaterialColor fromPrimitives(Object? data) {
    final value = (data as List).cast<int>();
    return MaterialColor(value[0], {
      50: Color(value[1]),
      100: Color(value[2]),
      200: Color(value[3]),
      300: Color(value[4]),
      400: Color(value[5]),
      500: Color(value[6]),
      600: Color(value[7]),
      700: Color(value[8]),
      800: Color(value[9]),
      900: Color(value[10]),
    });
  }

  @override
  Object? toPrimitives() => [
    value.value,
    value.shade50.value,
    value.shade100.value,
    value.shade200.value,
    value.shade300.value,
    value.shade400.value,
    value.shade500.value,
    value.shade600.value,
    value.shade700.value,
    value.shade800.value,
    value.shade900.value,
  ];
}

/// Each [RestorableProvider] must have a unique [RestorableProvider.restorationId]
final primaryMaterialColorProvider = RestorableProvider<RestorableMaterialColor>(
  (ref) => RestorableMaterialColor(Colors.blue),
  restorationId: 'primaryMaterialColorProvider',
);

final counterProvider = RestorableProvider<RestorableInt>(
  (ref) => RestorableInt(0),
  restorationId: 'counterProvider',
);

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),

      /// Required to restore state
      restorationScopeId: 'root',

      /// Required to register global providers for restoration
      builder: (context, child) => RestorableProviderRegister(
        restorationId: 'app',
        providers: [
          primaryMaterialColorProvider,
        ],
        child: child! //
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = ref.watch(primaryMaterialColorProvider).value;
    return Theme(
      data: ThemeData(primarySwatch: color),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                child: const Text("Open counter screen"),
                onPressed: () => _onCounter(context), // Original override code does not appear to be working.
              ),
              ElevatedButton(
                child: const Text("Random color"),
                onPressed: () {
                  final color = ref.read(primaryMaterialColorProvider);
                  color.value = (materialColors..shuffle()).first;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Use restorable navigation methods to remember current navigation state.
  /// Any arguments passed must be serializable by [StandardMessageCodec].
  String _onCounter(BuildContext context) {
    return Navigator.of(context).restorablePush(_buildRoute, arguments: 0);
  }

  /// Routes must be static in order to be restored.
  static Route<void> _buildRoute(BuildContext context, Object? params) {
    final int count = params as int;
    return MaterialPageRoute(
      builder: (BuildContext context) {
        /// If you want to overwrite a [RestorableProvider], you must use a [RestorableProviderScope].
        return RestorableProviderScope(
          restorationId: 'counter_page_scope',
          restorableOverrides: [
            counterProvider.overrideWithRestorable(RestorableInt(count)),
          ],
          child: const CounterPage(),
        );
      },
    );
  }
}

class CounterPage extends ConsumerWidget {
  const CounterPage({Key? key}) : super(key: key);

  void _incrementCounter(WidgetRef ref) {
    final counter = ref.read(counterProvider);
    counter.value++;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = ref.watch(primaryMaterialColorProvider).value;
    final counter = ref.watch(counterProvider);

    return Theme(
      data: ThemeData(primarySwatch: color),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Counter"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('You have pushed the button this many times:'),
              Text(
                '${counter.value}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _incrementCounter(ref),
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}