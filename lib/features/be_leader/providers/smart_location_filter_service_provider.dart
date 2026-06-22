import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/features/be_leader/presentation/services/smart_location_filter_service.dart';

/// مزود خدمة فلترة الموقع الذكي للمشرف.
/// مزود تقليدي (keepAlive افتراضياً) للحفاظ على حالة العدّادات طوال الجلسة.
final leaderLocationFilterServiceProvider =
    Provider<SmartLocationFilterService>((ref) {
  return SmartLocationFilterService();
});

/// مزود خدمة فلترة الموقع الذكي للحاج.
/// مزود تقليدي (keepAlive افتراضياً) للحفاظ على حالة العدّادات طوال الجلسة.
final pilgrimLocationFilterServiceProvider =
    Provider<SmartLocationFilterService>((ref) {
  return SmartLocationFilterService();
});
