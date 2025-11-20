import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_restorable/riverpod_restorable.dart';
import 'package:riverpod_restorable/src/restorable_state_provider.dart';

void main() {
  group('restorableProvider', () {
    test('creates provider with restoration ID', () {
      final provider = restorableProvider<RestorableInt>(
        create: (ref) => RestorableInt(0),
        restorationId: 'test',
      );

      expect(getRestorationId(provider), 'test');
    });

    test('provides restorable instance', () {
      final provider = restorableProvider<RestorableInt>(
        create: (ref) => RestorableInt(42),
        restorationId: 'test_instance',
      );

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final restorable = container.read(provider);
      expect(restorable, isA<RestorableInt>());
    });
  });

  group('RestorableProviderScope', () {
    testWidgets('widget rebuilds when restorable value changes', (tester) async {
      final provider = restorableProvider<RestorableInt>(
        create: (ref) => RestorableInt(0),
        restorationId: 'counter',
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            restorationScopeId: 'app',
            home: RestorableProviderScope(
              restorationId: 'test',
              providers: [provider],
              child: Consumer(
                builder: (context, ref, _) {
                  final counter = ref.watch(provider);
                  return Text('${counter.value}');
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('0'), findsOneWidget);

      final container = ProviderScope.containerOf(tester.element(find.byType(Consumer)));
      final counter = container.read(provider);
      counter.value++;

      await tester.pump();
      expect(find.text('1'), findsOneWidget);
    });
  });
}
