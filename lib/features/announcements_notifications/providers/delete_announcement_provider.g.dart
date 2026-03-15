// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_announcement_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DeleteAnnouncementNotifier)
const deleteAnnouncementProvider = DeleteAnnouncementNotifierProvider._();

final class DeleteAnnouncementNotifierProvider
    extends
        $AsyncNotifierProvider<
          DeleteAnnouncementNotifier,
          ApiResponse<dynamic>?
        > {
  const DeleteAnnouncementNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteAnnouncementProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteAnnouncementNotifierHash();

  @$internal
  @override
  DeleteAnnouncementNotifier create() => DeleteAnnouncementNotifier();
}

String _$deleteAnnouncementNotifierHash() =>
    r'af31c72e52b610034876383fa54222c39a188a66';

abstract class _$DeleteAnnouncementNotifier
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
