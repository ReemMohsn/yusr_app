// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_controller_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ResetPasswordController)
const resetPasswordControllerProvider = ResetPasswordControllerProvider._();

final class ResetPasswordControllerProvider
    extends
        $AsyncNotifierProvider<ResetPasswordController, ApiResponse<dynamic>?> {
  const ResetPasswordControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resetPasswordControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resetPasswordControllerHash();

  @$internal
  @override
  ResetPasswordController create() => ResetPasswordController();
}

String _$resetPasswordControllerHash() =>
    r'7e092d6fd816ae1f85c73cc84f8ae634db5cf408';

abstract class _$ResetPasswordController
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
