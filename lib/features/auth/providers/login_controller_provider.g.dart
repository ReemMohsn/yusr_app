// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_controller_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LoginController)
const loginControllerProvider = LoginControllerProvider._();

final class LoginControllerProvider
    extends
        $AsyncNotifierProvider<LoginController, ApiResponse<ProfileModel>?> {
  const LoginControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginControllerHash();

  @$internal
  @override
  LoginController create() => LoginController();
}

String _$loginControllerHash() => r'af48077aa349604979bfe85aff06ac5852aa6a20';

abstract class _$LoginController
    extends $AsyncNotifier<ApiResponse<ProfileModel>?> {
  FutureOr<ApiResponse<ProfileModel>?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<ApiResponse<ProfileModel>?>,
              ApiResponse<ProfileModel>?
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<ApiResponse<ProfileModel>?>,
                ApiResponse<ProfileModel>?
              >,
              AsyncValue<ApiResponse<ProfileModel>?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
