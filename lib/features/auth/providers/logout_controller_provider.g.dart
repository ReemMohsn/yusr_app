// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logout_controller_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LogoutController)
const logoutControllerProvider = LogoutControllerProvider._();

final class LogoutControllerProvider
    extends $AsyncNotifierProvider<LogoutController, void> {
  const LogoutControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'logoutControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$logoutControllerHash();

  @$internal
  @override
  LogoutController create() => LogoutController();
}

String _$logoutControllerHash() => r'65438d3c0487d4116ffe015b0d4f049b1137ada7';

abstract class _$LogoutController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
