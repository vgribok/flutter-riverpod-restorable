import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'restorable_provider.dart';

/// Place this in [WidgetsApp.builder] to automatically register the provided global [providers]
/// for restoration.
class RestorableProviderRegister extends ConsumerStatefulWidget {
  const RestorableProviderRegister({
    required this.restorationId,
    required this.providers,
    required this.child,
    Key? key,
  }) : super(key: key);

  /// {@macro flutter.widgets.widgetsApp.restorationScopeId}
  final String restorationId;
  final List<RestorableProvider<RestorableProperty?>> providers;
  final Widget child;

  @override
  _RestorableProviderRegisterState createState() =>
      _RestorableProviderRegisterState();
}

class _RestorableProviderRegisterState
    extends ConsumerState<RestorableProviderRegister> with RestorationMixin {
  @override
  Widget build(BuildContext context) {
    for (final provider in widget.providers) {
      ref.listen<RestorableProperty?>(provider, (previous, next) {
        if (identical(previous, next)) return;

        if (previous != null) unregisterFromRestoration(previous);
        if (next != null) registerForRestoration(next, provider.restorationId);
      });
    }
    return widget.child;
  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    for (final provider in widget.providers) {
      final value = ref.read(provider);
      if (value != null) registerForRestoration(value, provider.restorationId);
    }
  }
}
