import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: subtype_of_sealed_class
/// A [ChangeNotifierProvider] for [RestorableProperty]
class RestorableProvider<Restorable extends RestorableProperty?>
    extends ChangeNotifierProvider<Restorable> {
  RestorableProvider(
    Restorable Function(ChangeNotifierProviderRef<Restorable> ref) create, {
    required this.restorationId,
    String? name,
    List<ProviderOrFamily>? dependencies,
    Family? from,
    Object? argument,
  }) : super(
          create,
          name: name,
          dependencies: dependencies,
          from: from,
          argument: argument,
        );

  /// {@macro flutter.widgets.widgetsApp.restorationScopeId}
  final String restorationId;

  RestorableOverride<Restorable> overrideWithRestorable(Restorable value) {
    return RestorableOverride<Restorable>(this, value);
  }
}

class RestorableOverride<T extends RestorableProperty?> {
  const RestorableOverride(
    this.provider,
    this.value,
  );

  final RestorableProvider<T> provider;
  final T value;
}
