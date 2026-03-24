// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instructions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(instructionsRepository)
final instructionsRepositoryProvider = InstructionsRepositoryProvider._();

final class InstructionsRepositoryProvider
    extends
        $FunctionalProvider<
          InstructionsRepository,
          InstructionsRepository,
          InstructionsRepository
        >
    with $Provider<InstructionsRepository> {
  InstructionsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'instructionsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$instructionsRepositoryHash();

  @$internal
  @override
  $ProviderElement<InstructionsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InstructionsRepository create(Ref ref) {
    return instructionsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InstructionsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InstructionsRepository>(value),
    );
  }
}

String _$instructionsRepositoryHash() =>
    r'cd61b58ba8a45395c6caaf4dd77322073fa0aa21';

@ProviderFor(instructions)
final instructionsProvider = InstructionsFamily._();

final class InstructionsProvider
    extends
        $FunctionalProvider<
          List<InstructionModel>,
          List<InstructionModel>,
          List<InstructionModel>
        >
    with $Provider<List<InstructionModel>> {
  InstructionsProvider._({
    required InstructionsFamily super.from,
    required AppLocalizations super.argument,
  }) : super(
         retry: null,
         name: r'instructionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$instructionsHash();

  @override
  String toString() {
    return r'instructionsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<InstructionModel>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<InstructionModel> create(Ref ref) {
    final argument = this.argument as AppLocalizations;
    return instructions(ref, l10n: argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<InstructionModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<InstructionModel>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is InstructionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$instructionsHash() => r'16e00ec341cba8e8ac787b8fdaacb2389f9f6064';

final class InstructionsFamily extends $Family
    with $FunctionalFamilyOverride<List<InstructionModel>, AppLocalizations> {
  InstructionsFamily._()
    : super(
        retry: null,
        name: r'instructionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  InstructionsProvider call({required AppLocalizations l10n}) =>
      InstructionsProvider._(argument: l10n, from: this);

  @override
  String toString() => r'instructionsProvider';
}
