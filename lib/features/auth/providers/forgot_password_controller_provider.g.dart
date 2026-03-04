// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forgot_password_controller_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ForgotPasswordController)
const forgotPasswordControllerProvider = ForgotPasswordControllerProvider._();

final class ForgotPasswordControllerProvider
    extends
        $AsyncNotifierProvider<
          ForgotPasswordController,
          ApiResponse<dynamic>?
        > {
  const ForgotPasswordControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'forgotPasswordControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$forgotPasswordControllerHash();

  @$internal
  @override
  ForgotPasswordController create() => ForgotPasswordController();
}

String _$forgotPasswordControllerHash() =>
    r'c3fe2699c3e4bde002e1a21e93ae0778b4881b26';

abstract class _$ForgotPasswordController
    extends $AsyncNotifier<ApiResponse<dynamic>?> {
  FutureOr<ApiResponse<dynamic>?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<ApiResponse<dynamic>?>, ApiResponse<dynamic>?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<ApiResponse<dynamic>?>,
                ApiResponse<dynamic>?
              >,
              AsyncValue<ApiResponse<dynamic>?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
