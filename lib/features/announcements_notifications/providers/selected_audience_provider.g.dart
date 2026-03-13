// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_audience_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedAudience)
const selectedAudienceProvider = SelectedAudienceProvider._();

final class SelectedAudienceProvider
    extends $NotifierProvider<SelectedAudience, TargetAudience> {
  const SelectedAudienceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedAudienceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedAudienceHash();

  @$internal
  @override
  SelectedAudience create() => SelectedAudience();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TargetAudience value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TargetAudience>(value),
    );
  }
}

String _$selectedAudienceHash() => r'61941816493dc19265e2c49b05ef6582616431c7';

abstract class _$SelectedAudience extends $Notifier<TargetAudience> {
  TargetAudience build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<TargetAudience, TargetAudience>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TargetAudience, TargetAudience>,
              TargetAudience,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
