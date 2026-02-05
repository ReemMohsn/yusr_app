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
    extends $AsyncNotifierProvider<OtpVerificationController, void> {
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
    r'053f65d33efdf39766ad67093635c8980e8e3f15';

abstract class _$OtpVerificationController extends $AsyncNotifier<void> {
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
