enum TrackingType { tawaf, saee }

class AutoCounterState {
  final int currentLap;          // الشوط الحالي (1-7)
  final int totalLaps;           // إجمالي الأشواط (7)
  final bool isRunning;          // هل الحساسات تعمل الآن؟
  final bool isCompleted;        // هل تم الانتهاء من النسك بالكامل؟
  final int stepsInCurrentLap;   // عدد خطوات الشوط الحالي (للسعي)
  final double accumulatedAngle; // الزاوية التراكمية (للطواف)
  final bool isMoving;           // هل يتم رصد حركة مشي حقيقية حالياً؟
  final TrackingType trackingType; // نوع النسك الحالي
  
  // متغيرات السعي المتقدمة
  final double startHeading;     // اتجاه البوصلة عند بداية كل شوط
  final bool turnDetected;       // هل تم رصد التفاف U-Turn؟
  final String? permissionError; // لتخزين رسائل خطأ الحساسات إن وجدت

  const AutoCounterState({
    this.currentLap = 1,
    this.totalLaps = 7,
    this.isRunning = false,
    this.isCompleted = false,
    this.stepsInCurrentLap = 0,
    this.accumulatedAngle = 0.0,
    this.isMoving = false,
    this.trackingType = TrackingType.tawaf,
    this.startHeading = -1.0,
    this.turnDetected = false,
    this.permissionError,
  });

  // حساب الأشواط المتبقية (اختياري للواجهات)
  int get remainingLaps => (totalLaps - currentLap) + 1;

  // دالة copyWith لتحديث الحالة في الـ Controller دون فقدان البيانات الأخرى
  AutoCounterState copyWith({
    int? currentLap,
    int? totalLaps,
    bool? isRunning,
    bool? isCompleted,
    int? stepsInCurrentLap,
    double? accumulatedAngle,
    bool? isMoving,
    TrackingType? trackingType,
    double? startHeading,
    bool? turnDetected,
    String? permissionError,
  }) {
    return AutoCounterState(
      currentLap: currentLap ?? this.currentLap,
      totalLaps: totalLaps ?? this.totalLaps,
      isRunning: isRunning ?? this.isRunning,
      isCompleted: isCompleted ?? this.isCompleted,
      stepsInCurrentLap: stepsInCurrentLap ?? this.stepsInCurrentLap,
      accumulatedAngle: accumulatedAngle ?? this.accumulatedAngle,
      isMoving: isMoving ?? this.isMoving,
      trackingType: trackingType ?? this.trackingType,
      startHeading: startHeading ?? this.startHeading,
      turnDetected: turnDetected ?? this.turnDetected,
      permissionError: permissionError ?? this.permissionError,
    );
  }

  // دالة اختيارية لتمثيل الحالة كنص (مفيدة في الـ Debugging)
  @override
  String toString() {
    return 'AutoCounterState(Lap: $currentLap, Moving: $isMoving, Steps: $stepsInCurrentLap, Turn: $turnDetected)';
  }
}