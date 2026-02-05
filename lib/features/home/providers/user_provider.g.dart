// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserProfile)
const userProfileProvider = UserProfileProvider._();

final class UserProfileProvider
    extends $AsyncNotifierProvider<UserProfile, ProfileModel?> {
  const UserProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userProfileHash();

  @$internal
  @override
  UserProfile create() => UserProfile();
}

String _$userProfileHash() => r'38f98eeeecf198990f67d5c533215ed1f848965c';

abstract class _$UserProfile extends $AsyncNotifier<ProfileModel?> {
  FutureOr<ProfileModel?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<ProfileModel?>, ProfileModel?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ProfileModel?>, ProfileModel?>,
              AsyncValue<ProfileModel?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
