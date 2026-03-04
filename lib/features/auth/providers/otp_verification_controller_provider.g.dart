// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_verification_controller_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OtpVerificationController)
const otpVerificationControllerProvider = OtpVerificationControllerProvider._();

final class OtpVerificationControllerProvider
    extends
        $AsyncNotifierProvider<
          OtpVerificationController,
          ApiResponse<dynamic>?
        > {
  const OtpVerificationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'otpVerificationControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$otpVerificationControllerHash();

  @$internal
  @override
  OtpVerificationController create() => OtpVerificationController();
}

String _$otpVerificationControllerHash() =>
    r'184d2b2e167cea900138b61e25bdb80080733dd3';

abstract class _$OtpVerificationController
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
