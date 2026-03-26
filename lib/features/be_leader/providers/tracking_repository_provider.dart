import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/features/be_leader/data/repositories/tracking_repository.dart';

part 'tracking_repository_provider.g.dart';

@riverpod
TrackingRepository trackingRepository(Ref ref) {
  return TrackingRepository(ref);
}
