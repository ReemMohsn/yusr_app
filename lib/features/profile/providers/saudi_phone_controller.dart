import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/features/profile/providers/profile_repository_provider.dart';

final saudiPhoneControllerProvider =
    AsyncNotifierProvider<SaudiPhoneController, void>(
  SaudiPhoneController.new,
);

class SaudiPhoneController extends AsyncNotifier<void> {

  @override
  FutureOr<void> build() {
    // Initial state is data(null) implicitly
  }

  Future<void> updateSaudiNumber(String newNumber) async {
    state = const AsyncLoading();
    final repository = ref.read(profileRepositoryProvider);

    try {
      // 1. Fetch current raw details
      final fetchRes = await repository.getRawUserDetails();
      final currentData = fetchRes.data;

      // Ensure data was successfully fetched
      if (currentData == null) {
        state = AsyncError('Failed to load current profile data', StackTrace.current);
        return;
      }

      // 2. Clone the map and only update the saudiContactNumber
      final Map<String, dynamic> updatedData = Map<String, dynamic>.from(currentData);
      updatedData['saudiContactNumber'] = '+966$newNumber';

      // 3. Post the updated object
      final updateRes = await repository.updateProfileRaw(updatedData);
      
      // Assume the success message is valid or data is returned.
      // If the API failed structurally, an exception would likely throw from repositoryRequestHandler.
      if (updateRes.message.toLowerCase().contains('error')) {
        state = AsyncError('Failed to update phone number: ${updateRes.message}', StackTrace.current);
        return;
      }

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e.toString(), st);
    }
  }
}

