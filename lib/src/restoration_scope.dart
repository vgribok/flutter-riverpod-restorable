import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'restorable_state_provider.dart';

/// Widget that registers restorable providers for state restoration.
class RestorableProviderScope extends ConsumerStatefulWidget {
  const RestorableProviderScope({
    required this.restorationId,
    required this.providers,
    required this.child,
    super.key,
  });

  final String restorationId;
  final List<NotifierProvider> providers;
  final Widget child;

  @override
  ConsumerState<RestorableProviderScope> createState() => _RestorableProviderScopeState();
}

class _RestorableProviderScopeState extends ConsumerState<RestorableProviderScope>
    with RestorationMixin {

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    for (final provider in widget.providers) {
      final restorationId = getRestorationId(provider);
      if (restorationId != null) {
        final restorable = ref.read(provider) as RestorableProperty;
        registerForRestoration(restorable, restorationId);
      }
    }
  }
}
