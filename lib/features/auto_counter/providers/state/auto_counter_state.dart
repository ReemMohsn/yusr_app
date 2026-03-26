// lib/features/auto_counter/providers/state/auto_counter_state.dart

enum TrackingType { tawaf, saee }

class AutoCounterState {
  final TrackingType trackingType; // نوع النسك (طواف/سعي)
  final int currentLap; // الشوط الحالي
  final int totalLaps; // الإجمالي (7)
  final double accumulatedAngle; // الزاوية التراكمية (للحساسات)
  final int stepsInCurrentLap; // الخطوات في الشوط الحالي
  final bool isRunning; // هل العداد يعمل الآن؟
  final bool isCompleted; // هل انتهت الـ 7 أشواط؟

  const AutoCounterState({
    this.trackingType = TrackingType.tawaf,
    this.currentLap = 0,
    this.totalLaps = 7,
    this.accumulatedAngle = 0.0,
    this.stepsInCurrentLap = 0,
    this.isRunning = false,
    this.isCompleted = false,
  });

  // المتبقي (يُحسب تلقائياً للواجهة)
  int get remainingLaps => totalLaps - currentLap;

  // دالة لتحديث قيم معينة مع الحفاظ على البقية
  AutoCounterState copyWith({
    TrackingType? trackingType,
    int? currentLap,
    int? totalLaps,
    double? accumulatedAngle,
    int? stepsInCurrentLap,
    bool? isRunning,
    bool? isCompleted,
  }) {
    return AutoCounterState(
      trackingType: trackingType ?? this.trackingType,
      currentLap: currentLap ?? this.currentLap,
      totalLaps: totalLaps ?? this.totalLaps,
      accumulatedAngle: accumulatedAngle ?? this.accumulatedAngle,
      stepsInCurrentLap: stepsInCurrentLap ?? this.stepsInCurrentLap,
      isRunning: isRunning ?? this.isRunning,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
