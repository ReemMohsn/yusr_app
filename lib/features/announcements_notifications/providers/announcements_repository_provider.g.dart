// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcements_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(announcementsRepository)
const announcementsRepositoryProvider = AnnouncementsRepositoryProvider._();

final class AnnouncementsRepositoryProvider
    extends
        $FunctionalProvider<
          AnnouncementsRepository,
          AnnouncementsRepository,
          AnnouncementsRepository
        >
    with $Provider<AnnouncementsRepository> {
  const AnnouncementsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'announcementsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$announcementsRepositoryHash();

  @$internal
  @override
  $ProviderElement<AnnouncementsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AnnouncementsRepository create(Ref ref) {
    return announcementsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnnouncementsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnnouncementsRepository>(value),
    );
  }
}

String _$announcementsRepositoryHash() =>
    r'6202fae61d8fd9d717f0864a0a90ff0400618882';
