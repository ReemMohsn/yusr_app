// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_announcement_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AddAnnouncementNotifier)
const addAnnouncementProvider = AddAnnouncementNotifierProvider._();

final class AddAnnouncementNotifierProvider
    extends
        $AsyncNotifierProvider<AddAnnouncementNotifier, ApiResponse<dynamic>?> {
  const AddAnnouncementNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addAnnouncementProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addAnnouncementNotifierHash();

  @$internal
  @override
  AddAnnouncementNotifier create() => AddAnnouncementNotifier();
}

String _$addAnnouncementNotifierHash() =>
    r'48556eceffe47ca8230c82710a7d7c78d772c0fc';

abstract class _$AddAnnouncementNotifier
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
