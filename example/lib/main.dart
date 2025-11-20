import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_restorable/riverpod_restorable.dart';

/// To test: Enable "Don't keep activities" in Android Developer Options.
/// Hit Home button to evict the app, then return - state should be preserved.
void main() => runApp(const ProviderScope(child: MyApp()));

// Create restorable providers
final counterProvider = restorableProvider<RestorableInt>(
  create: (ref) => RestorableInt(0),
  restorationId: 'counter',
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod Restorable Demo',
      restorationScopeId: 'app',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RestorableProviderScope(
        restorationId: 'main',
        providers: [counterProvider],
        child: const HomePage(),
      ),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod Restorable Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '${counter.value}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 32),
            const Text(
              'Try: Press Home, then return to app.\nThe counter should be preserved!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => counter.value++,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
