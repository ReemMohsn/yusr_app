// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filtered_announcements_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FilteredAnnouncements)
final filteredAnnouncementsProvider = FilteredAnnouncementsProvider._();

final class FilteredAnnouncementsProvider
    extends
        $NotifierProvider<
          FilteredAnnouncements,
          AsyncValue<List<AnnouncementModel>>
        > {
  FilteredAnnouncementsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredAnnouncementsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredAnnouncementsHash();

  @$internal
  @override
  FilteredAnnouncements create() => FilteredAnnouncements();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<AnnouncementModel>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<AnnouncementModel>>>(
        value,
      ),
    );
  }
}

String _$filteredAnnouncementsHash() =>
    r'ff91127ba50939fbe85a5ff505194515f29129dc';

abstract class _$FilteredAnnouncements
    extends $Notifier<AsyncValue<List<AnnouncementModel>>> {
  AsyncValue<List<AnnouncementModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<AnnouncementModel>>,
              AsyncValue<List<AnnouncementModel>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<AnnouncementModel>>,
                AsyncValue<List<AnnouncementModel>>
              >,
              AsyncValue<List<AnnouncementModel>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
