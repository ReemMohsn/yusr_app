import 'package:flutter_riverpod/legacy.dart';

final passwordVisibilityProvider = StateProvider.autoDispose<bool>(
  (ref) => false,
);
