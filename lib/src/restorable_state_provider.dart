import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Creates a Provider that holds a RestorableProperty.
///
/// This integrates Flutter's restoration system with Riverpod v.3.
NotifierProvider<RestorableNotifierImpl<T>, T> restorableProvider<T extends RestorableProperty<Object?>>({
  required T Function(Ref ref) create,
  required String restorationId,
  String? name,
}) {
  final provider = NotifierProvider<RestorableNotifierImpl<T>, T>(
    () => RestorableNotifierImpl(create),
    name: name,
  );
  _restorationIds[provider] = restorationId;
  return provider;
}

/// Notifier that wraps RestorableProperty for Riverpod reactivity.
class RestorableNotifierImpl<T extends RestorableProperty<Object?>> extends Notifier<T> {
  RestorableNotifierImpl(this._create);

  final T Function(Ref ref) _create;
  _RestorableWrapper<T>? _wrapper;

  @override
  T build() {
    final property = _create(ref);
    _wrapper = _RestorableWrapper(property);
    _wrapper!.addListener(() {
      ref.notifyListeners();
    });
    ref.onDispose(() => _wrapper?.dispose());
    return property;
  }
}

/// Internal wrapper for RestorableProperty change notifications.
class _RestorableWrapper<T extends RestorableProperty<Object?>> extends ChangeNotifier {
  _RestorableWrapper(this.property) {
    property.addListener(notifyListeners);
  }

  final T property;

  @override
  void dispose() {
    property.removeListener(notifyListeners);
    property.dispose();
    super.dispose();
  }
}

/// Internal map to store restoration IDs
final _restorationIds = <NotifierProvider, String>{};

/// Get restoration ID for a provider
String? getRestorationId(NotifierProvider provider) => _restorationIds[provider];
