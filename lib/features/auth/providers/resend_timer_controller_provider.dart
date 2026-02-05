import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'resend_timer_controller_provider.g.dart';

@riverpod
class ResendTimerController extends _$ResendTimerController {
  Timer? _timer;
  static const int _initialTime = 60; // عدد الثواني

  @override
  int build() {
    // عند تدمير البروفايدر (الخروج من الصفحة)، نلغي المؤقت لتجنب تهريب الذاكرة
    ref.onDispose(() {
      _timer?.cancel();
    });
    // القيمة الافتراضية 0 تعني أن الزر مفعل، لكننا سنبدأه يدوياً عند فتح الصفحة
    return 0;
  }

  void startTimer() {
    _timer?.cancel();
    state = _initialTime; // إعادة تعيين الوقت إلى 60

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state > 0) {
        state = state - 1; // إنقاص الوقت وتحديث الواجهة تلقائياً
      } else {
        timer.cancel(); // إيقاف المؤقت عند الوصول لصفر
      }
    });
  }
}
