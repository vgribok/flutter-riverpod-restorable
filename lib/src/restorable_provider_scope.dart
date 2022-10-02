import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'restorable_provider.dart';

/// A [ProviderScope] that automatically registers overridden RestorableProvider for restoration
class RestorableProviderScope extends ConsumerStatefulWidget {
  const RestorableProviderScope({
    required this.restorationId,
    required this.restorableOverrides,
    this.overrides = const [],
    this.observers,
    //this.cacheTime,
    //this.disposeDelay,
    this.parent,
    required this.child,
    Key? key,
  }) : super(key: key);

  /// {@macro flutter.widgets.widgetsApp.restorationScopeId}
  final String restorationId;
  final List<RestorableOverride<RestorableProperty?>> restorableOverrides;
  final Widget child;

  final List<Override> overrides;
  final List<ProviderObserver>? observers;
  //final Duration? cacheTime;
  //final Duration? disposeDelay;
  final ProviderContainer? parent;

  @override
  _RestorableProviderScopeState createState() =>
      _RestorableProviderScopeState();
}

class _RestorableProviderScopeState
    extends ConsumerState<RestorableProviderScope> with RestorationMixin {
  late List<RestorableOverride<RestorableProperty?>> overrides;

  @override
  void initState() {
    super.initState();

    overrides = widget.restorableOverrides;
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        ...widget.overrides,
        for (final RestorableOverride<RestorableProperty?> override in overrides)
          override.provider.overrideWithProvider(override.provider),
      ],
      observers: widget.observers,
      //cacheTime: widget.cacheTime,
      //disposeDelay: widget.disposeDelay,
      child: widget.child,
    );
  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    for (final override in overrides) {
      final value = override.value;
      if (value != null) {
        registerForRestoration(value, override.provider.restorationId);
      }
    }
  }
}
