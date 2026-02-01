// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_index_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CurrentIndexController)
const currentIndexControllerProvider = CurrentIndexControllerProvider._();

final class CurrentIndexControllerProvider
    extends $NotifierProvider<CurrentIndexController, int> {
  const CurrentIndexControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentIndexControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentIndexControllerHash();

  @$internal
  @override
  CurrentIndexController create() => CurrentIndexController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$currentIndexControllerHash() =>
    r'b50ce0e2ce4696ed4e444d0d0633f511c8679b4f';

abstract class _$CurrentIndexController extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
