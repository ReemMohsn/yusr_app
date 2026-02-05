// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resend_timer_controller_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ResendTimerController)
const resendTimerControllerProvider = ResendTimerControllerProvider._();

final class ResendTimerControllerProvider
    extends $NotifierProvider<ResendTimerController, int> {
  const ResendTimerControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resendTimerControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resendTimerControllerHash();

  @$internal
  @override
  ResendTimerController create() => ResendTimerController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$resendTimerControllerHash() =>
    r'3fd68b2f351134851ea3f0c988937274c3b85612';

abstract class _$ResendTimerController extends $Notifier<int> {
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
