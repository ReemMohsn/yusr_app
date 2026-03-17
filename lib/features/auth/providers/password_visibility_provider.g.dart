// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_visibility_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PasswordVisibility)
final passwordVisibilityProvider = PasswordVisibilityProvider._();

final class PasswordVisibilityProvider
    extends $NotifierProvider<PasswordVisibility, bool> {
  PasswordVisibilityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'passwordVisibilityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$passwordVisibilityHash();

  @$internal
  @override
  PasswordVisibility create() => PasswordVisibility();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$passwordVisibilityHash() =>
    r'0497d63d25094d18d2962ad9105876918887fc25';

abstract class _$PasswordVisibility extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(PasswordTwoVisibility)
final passwordTwoVisibilityProvider = PasswordTwoVisibilityProvider._();

final class PasswordTwoVisibilityProvider
    extends $NotifierProvider<PasswordTwoVisibility, bool> {
  PasswordTwoVisibilityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'passwordTwoVisibilityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$passwordTwoVisibilityHash();

  @$internal
  @override
  PasswordTwoVisibility create() => PasswordTwoVisibility();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$passwordTwoVisibilityHash() =>
    r'e3520ae22482563cea8a673d83832ed6f7a13a24';

abstract class _$PasswordTwoVisibility extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
