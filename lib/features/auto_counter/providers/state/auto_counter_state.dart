enum TrackingType { tawaf, saee }

class AutoCounterState {
  final TrackingType trackingType; // نوع النسك (طواف/سعي)
  final int currentLap; // الشوط الحالي
  final int totalLaps; // الإجمالي (7)
  final double accumulatedAngle; // الزاوية التراكمية (للطواف)
  final int stepsInCurrentLap; // الخطوات في الشوط الحالي (للسعي)
  final int startSteps; // نقطة البداية للخطوات في كل شوط
  final bool isMoving; // فلتر الأمان (ZUPT) لمنع الحساب أثناء الوقوف
  final bool isRunning; // هل العداد يعمل الآن؟
  final bool isCompleted; // هل انتهت الـ 7 أشواط؟
  final String? permissionError; // الحقل الجديد: لتخزين رسائل خطأ التصاريح

  const AutoCounterState({
    this.trackingType = TrackingType.tawaf,
    this.currentLap = 0,
    this.totalLaps = 7,
    this.accumulatedAngle = 0.0,
    this.stepsInCurrentLap = 0,
    this.startSteps = 0,
    this.isMoving = false,
    this.isRunning = false,
    this.isCompleted = false,
    this.permissionError, // القيمة الافتراضية null
  });

  // المتبقي (يُحسب تلقائياً للواجهة)
  int get remainingLaps => totalLaps - currentLap;

  // دالة copyWith المحدثة لتشمل كافة الحقول
  AutoCounterState copyWith({
    TrackingType? trackingType,
    int? currentLap,
    int? totalLaps,
    double? accumulatedAngle,
    int? stepsInCurrentLap,
    int? startSteps,
    bool? isMoving,
    bool? isRunning,
    bool? isCompleted,
    String? permissionError, // إضافة الحقل هنا
  }) {
    return AutoCounterState(
      trackingType: trackingType ?? this.trackingType,
      currentLap: currentLap ?? this.currentLap,
      totalLaps: totalLaps ?? this.totalLaps,
      accumulatedAngle: accumulatedAngle ?? this.accumulatedAngle,
      stepsInCurrentLap: stepsInCurrentLap ?? this.stepsInCurrentLap,
      startSteps: startSteps ?? this.startSteps,
      isMoving: isMoving ?? this.isMoving,
      isRunning: isRunning ?? this.isRunning,
      isCompleted: isCompleted ?? this.isCompleted,
      permissionError: permissionError ?? this.permissionError, // وهنا أيضاً
    );
  }
}
