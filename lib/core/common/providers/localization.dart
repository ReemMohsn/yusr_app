import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'localization.g.dart';

@riverpod
class Localization extends _$Localization {
  @override
  Locale? build() {
    return const Locale('ar');
  }

  void setLocale(Locale newLocale) {
    state = newLocale;
  }

  bool isArabic() {
    return state?.languageCode == 'ar';
  }
}
