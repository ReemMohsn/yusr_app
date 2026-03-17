// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instructions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(instructions)
final instructionsProvider = InstructionsProvider._();

final class InstructionsProvider
    extends
        $FunctionalProvider<
          List<InstructionModel>,
          List<InstructionModel>,
          List<InstructionModel>
        >
    with $Provider<List<InstructionModel>> {
  InstructionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'instructionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$instructionsHash();

  @$internal
  @override
  $ProviderElement<List<InstructionModel>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<InstructionModel> create(Ref ref) {
    return instructions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<InstructionModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<InstructionModel>>(value),
    );
  }
}

String _$instructionsHash() => r'1630e3921b88688c4a932164d743881ec9d30039';
