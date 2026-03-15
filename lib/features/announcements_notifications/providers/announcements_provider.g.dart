// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcements_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(announcements)
const announcementsProvider = AnnouncementsProvider._();

final class AnnouncementsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AnnouncementModel>>,
          List<AnnouncementModel>,
          FutureOr<List<AnnouncementModel>>
        >
    with
        $FutureModifier<List<AnnouncementModel>>,
        $FutureProvider<List<AnnouncementModel>> {
  const AnnouncementsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'announcementsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$announcementsHash();

  @$internal
  @override
  $FutureProviderElement<List<AnnouncementModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AnnouncementModel>> create(Ref ref) {
    return announcements(ref);
  }
}

String _$announcementsHash() => r'73d55acd9899cb8adede1f0767fb1800f16b49df';
